# Phase 1: Compliance & Manifest Intelligence - Research

**Researched:** 2026-04-11
**Phase:** 01-compliance-manifest-intelligence
**Status:** Research complete

## Research Summary

This phase builds three interconnected systems: (1) Gemini-powered BMR extraction, (2) deterministic compliance rule engine, (3) React frontend for upload + dashboard. Research covers the technical approaches, libraries, data sources, and architecture patterns needed.

---

## 1. Gemini PDF Extraction Pipeline

### Approach: Native Structured Output with Pydantic

**Recommended:** Use `google-genai` Python SDK with Pydantic schema enforcement and `response_mime_type="application/json"`.

**How it works:**
1. Upload PDF via Gemini Files API (supports up to 1000 pages / 50MB)
2. Define Pydantic models for the extraction schema (APIs, excipients, controlled substances)
3. Call `generate_content` with `response_schema=ExtractedIngredients` — guarantees valid JSON output
4. Post-process: validate extracted CAS numbers against substance lookup DB

**Key Libraries:**
- `google-genai` (official Google GenAI SDK)
- `pydantic` v2 (schema definition + validation)
- No OCR pipeline needed — Gemini handles document understanding natively (tables, layouts, handwriting)

**Extraction Schema (recommended):**
```python
class Ingredient(BaseModel):
    name: str                    # Substance name as written in BMR
    role: Literal["api", "excipient", "controlled", "coating", "binder"]
    cas_number: Optional[str]    # CAS Registry Number
    inn_name: Optional[str]      # International Nonproprietary Name
    concentration: Optional[str] # Amount per unit dose
    confidence: float            # 0.0-1.0 extraction confidence

class ExtractionResult(BaseModel):
    product_name: str
    dosage_form: str
    ingredients: list[Ingredient]
    batch_number: Optional[str]
    manufacturing_date: Optional[str]
```

**Failure Handling:**
- If confidence < 0.7 for any field: flag it visually in HITL review
- If PDF is unreadable / upload fails: return error with clear message
- Partial extraction is acceptable — the HITL step catches gaps

### Dependencies
- `google-genai>=1.0.0`
- `pydantic>=2.0`
- `python-multipart` (for FastAPI file uploads)

---

## 2. Substance Lookup Database

### Data Strategy: Hardcoded Demo Set + Extensible Schema

**For hackathon MVP:** Seed a PostgreSQL table with the demo scenario substances + a broader set of ~50 common pharma APIs. Full WHO/FDA database integration is post-hackathon (v2).

**Seed Data Sources:**
- **Demo substances (mandatory):** Amoxicillin trihydrate (CAS 61336-70-7), Clavulanate potassium (CAS 61177-45-5), Microcrystalline cellulose (CAS 9004-34-6), Magnesium stearate (CAS 557-04-0)
- **Broader set:** Top 50 generic APIs from India's pharma export list (publicly available from CDSCO/Pharmexcil)
- **Regulatory identifiers:** EC numbers (EU), DEA schedule codes (US), CDSCO approval status (India)

**Schema:**
```sql
CREATE TABLE substances (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    cas_number VARCHAR(20) UNIQUE,
    inn_name VARCHAR(255),
    ec_number VARCHAR(20),           -- EU EC substance identifier
    dea_schedule VARCHAR(10),        -- US DEA schedule (I-V or null)
    cdsco_status VARCHAR(50),        -- India CDSCO approval status
    is_controlled BOOLEAN DEFAULT FALSE,
    scheduling_notes JSONB,          -- Per-country scheduling details
    created_at TIMESTAMP DEFAULT NOW()
);
```

**Matching Strategy:** Exact-match on CAS number (primary), fuzzy match on INN name (secondary fallback). NO LLM for substance identification — this is the critical anti-hallucination decision.

---

## 3. Compliance Rule Engine

### Architecture: Configurable Rule Table + Generic Evaluator

**Rule Table Schema:**
```sql
CREATE TABLE compliance_rules (
    id SERIAL PRIMARY KEY,
    country_code VARCHAR(3) NOT NULL,     -- ISO 3166-1 alpha-3 (NLD, USA, etc.)
    check_type VARCHAR(50) NOT NULL,      -- 'scheduling', 'permit', 'serialisation', 'labelling', 'cold_chain'
    rule_name VARCHAR(255) NOT NULL,
    condition_field VARCHAR(100),          -- Field to check (e.g., 'dea_schedule', 'is_controlled')
    condition_operator VARCHAR(20),        -- 'equals', 'not_null', 'in_list', 'greater_than'
    condition_value TEXT,                  -- Value to compare against
    severity VARCHAR(10) NOT NULL,        -- 'red', 'amber', 'green'
    remediation_template TEXT,            -- Template for Gemini to expand into human-readable guidance
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);
```

**Generic Evaluation Engine:**
```python
def evaluate_shipment(shipment, destination_country):
    rules = db.query(ComplianceRule).filter(
        country_code=destination_country,
        is_active=True
    ).all()
    
    results = []
    for rule in rules:
        passed = evaluate_condition(shipment, rule)
        if not passed:
            remediation = generate_remediation(rule, shipment)  # Gemini call
        results.append(ComplianceResult(rule=rule, passed=passed, remediation=remediation))
    
    return results
```

**MVP Rules (EU - Netherlands + US):**

| Country | Check Type | Rule | Severity if Fail |
|---------|-----------|------|-------------------|
| NLD | scheduling | No banned substances in EU Annex | RED |
| NLD | permit | Dutch import drug license required | AMBER |
| NLD | serialisation | EU FMD serialisation identifiers present | RED |
| NLD | labelling | GDP cold chain labelling requirements met | AMBER |
| USA | scheduling | DEA schedule check — controlled substances flagged | RED |
| USA | permit | FDA import alert check | RED |
| USA | labelling | US labelling requirements (NDC, lot number) | AMBER |

**Gemini Remediation Generation:**
When a rule fails, pass the rule template + shipment context to Gemini to generate a human-readable explanation. Example prompt:
```
Explain this compliance failure to a pharma export manager:
Rule: {rule_name}
Failed because: {condition details}
Shipment: {product_name} to {destination}
Generate a 2-3 sentence explanation with specific remediation steps.
```

---

## 4. FastAPI Backend Architecture

### Project Structure
```
backend/
├── app/
│   ├── __init__.py
│   ├── main.py                 # FastAPI app, CORS, middleware
│   ├── config.py               # Settings (API keys, DB URL)
│   ├── database.py             # SQLAlchemy/asyncpg setup
│   ├── models/                 # SQLAlchemy ORM models
│   │   ├── substance.py
│   │   ├── shipment.py
│   │   ├── compliance_rule.py
│   │   └── job.py
│   ├── schemas/                # Pydantic request/response schemas
│   │   ├── extraction.py
│   │   ├── compliance.py
│   │   └── shipment.py
│   ├── services/               # Business logic
│   │   ├── extraction.py       # Gemini PDF extraction
│   │   ├── compliance.py       # Rule evaluation engine
│   │   ├── substance_lookup.py # CAS/INN exact-match
│   │   └── remediation.py     # Gemini remediation generation
│   ├── api/                    # Route handlers
│   │   ├── upload.py           # POST /api/upload
│   │   ├── shipments.py        # CRUD /api/shipments
│   │   ├── compliance.py       # GET /api/compliance/{id}
│   │   └── jobs.py             # GET /api/jobs/{id}/stream (SSE)
│   └── core/
│       ├── security.py         # Data privacy enforcement
│       └── background.py       # Background task management
├── seed/                       # Database seed scripts
│   ├── substances.json         # Demo + common substance data
│   └── compliance_rules.json   # MVP compliance rules
├── requirements.txt
├── Dockerfile
└── docker-compose.yml          # PostgreSQL + app
```

### Async Job + SSE Pattern

**Job lifecycle:**
1. `POST /api/upload` → creates job, starts BackgroundTask, returns `{job_id}`
2. BackgroundTask: parse PDF → extract ingredients → validate against substance DB → run compliance checks
3. Each step pushes status update to an `asyncio.Queue` keyed by job_id
4. `GET /api/jobs/{job_id}/stream` → SSE endpoint that streams from the queue

**SSE Response Format:**
```
data: {"step": "uploading", "progress": 100, "message": "File received"}

data: {"step": "extracting", "progress": 30, "message": "Parsing batch record..."}

data: {"step": "extracting", "progress": 80, "message": "Extracted 4 ingredients"}

data: {"step": "validating", "progress": 50, "message": "Checking substance database..."}

data: {"step": "compliance", "progress": 70, "message": "Running EU compliance checks..."}

data: {"step": "complete", "progress": 100, "message": "Done", "result_id": "ship-123"}
```

### API Endpoints (Phase 1)

| Method | Path | Purpose |
|--------|------|---------|
| POST | `/api/upload` | Upload BMR PDF, start extraction job |
| GET | `/api/jobs/{id}/stream` | SSE stream of job progress |
| GET | `/api/shipments/{id}` | Get shipment with extracted data |
| PUT | `/api/shipments/{id}/confirm` | HITL confirmation of extraction |
| GET | `/api/shipments/{id}/compliance` | Get compliance check results |
| POST | `/api/shipments/{id}/export` | Generate final packing list (post-HITL) |
| GET | `/api/substances/search` | Search substance DB by CAS/name |

### Dependencies
- `fastapi>=0.110.0`
- `uvicorn[standard]`
- `sqlalchemy>=2.0` + `asyncpg` (async PostgreSQL)
- `alembic` (migrations)
- `python-multipart` (file uploads)
- `google-genai>=1.0.0`
- `pydantic>=2.0`
- `pydantic-settings`

---

## 5. React Frontend Architecture

### Project Structure
```
frontend/
├── src/
│   ├── App.tsx
│   ├── main.tsx
│   ├── api/                    # API client + types
│   │   ├── client.ts           # axios instance with base URL
│   │   ├── types.ts            # Shared TypeScript interfaces
│   │   └── sse.ts              # EventSource helper for SSE
│   ├── features/
│   │   ├── upload/             # BMR upload feature
│   │   │   ├── UploadZone.tsx
│   │   │   ├── UploadProgress.tsx
│   │   │   └── useUpload.ts
│   │   ├── extraction/         # Extraction review + HITL
│   │   │   ├── ExtractionReview.tsx
│   │   │   ├── IngredientTable.tsx
│   │   │   └── useExtraction.ts
│   │   ├── compliance/         # Compliance dashboard
│   │   │   ├── ComplianceDashboard.tsx
│   │   │   ├── TrafficLight.tsx
│   │   │   ├── CheckResult.tsx
│   │   │   └── useCompliance.ts
│   │   └── export/             # Packing list export
│   │       ├── PackingListPreview.tsx
│   │       └── useExport.ts
│   ├── components/             # Shared UI components
│   │   ├── Layout.tsx
│   │   ├── Stepper.tsx
│   │   ├── StatusBadge.tsx
│   │   └── LoadingOverlay.tsx
│   └── styles/
│       └── globals.css
├── package.json
├── tsconfig.json
├── vite.config.ts
└── index.html
```

### Key Libraries
- `react` + `react-dom` (v18+)
- `typescript`
- `vite` (build tool)
- `axios` (HTTP client with upload progress)
- `react-dropzone` (drag-and-drop file upload)
- `react-router-dom` (routing, minimal for Phase 1)

### SSE Client Pattern
```typescript
function useJobStream(jobId: string) {
  const [status, setStatus] = useState<JobStatus>({ step: 'idle', progress: 0 });
  
  useEffect(() => {
    if (!jobId) return;
    const source = new EventSource(`/api/jobs/${jobId}/stream`);
    source.onmessage = (event) => {
      const data = JSON.parse(event.data);
      setStatus(data);
      if (data.step === 'complete' || data.step === 'error') {
        source.close();
      }
    };
    return () => source.close();
  }, [jobId]);
  
  return status;
}
```

---

## 6. Data Security Implementation

### Zero Training-Data Retention
- Configure Gemini API with `safety_settings` and ensure API key is not linked to training data programs
- BMR files processed in-memory, never persisted to disk beyond the upload step
- Extracted JSON stored in PostgreSQL (structured data only, not raw PDF)
- Raw PDF deleted from server after extraction completes
- All API responses exclude raw document content

### Privacy Controls
- File uploads validated: only PDF accepted, max 50MB
- No logging of file contents or extracted substance data in application logs
- Database-level encryption at rest (PostgreSQL)
- CORS restricted to frontend origin only

---

## 7. Technical Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Gemini extraction accuracy on complex BMR layouts | Incorrect ingredient identification | Confidence scoring + HITL confirmation; use structured output for consistency |
| CAS number not found in seed DB | Compliance check cannot run | Flag as "unverified substance" — still allow HITL but warn about incomplete compliance |
| SSE connection drops | User loses progress visibility | Frontend auto-reconnects EventSource; job state persisted in DB for recovery |
| Long extraction time (>30s) | Poor demo UX | Pre-upload a sample BMR, cache extraction results for demo; optimize prompts |
| PostgreSQL cold start on Cloud Run | First request slow | Use connection pooling (asyncpg pool), keep-alive on Cloud Run |

---

## Validation Architecture

### Verification Strategy

**Unit Tests:**
- Extraction schema validation (Pydantic model tests)
- Compliance rule evaluation logic (deterministic — fully testable)
- Substance lookup exact-match logic

**Integration Tests:**
- Upload → Extract → Compliance pipeline end-to-end
- SSE streaming from job creation to completion
- HITL confirmation → packing list generation

**Demo Validation:**
- Amoxicillin-Clavulanate BMR produces correct extraction (4 ingredients)
- EU (Netherlands) compliance passes all checks when data is correct
- Traffic-light dashboard renders correctly with mixed pass/fail results
- Full flow completes in under 90 seconds (Step 1 of demo is 90s)

---

## RESEARCH COMPLETE

*Phase: 01-compliance-manifest-intelligence*
*Research completed: 2026-04-11*
