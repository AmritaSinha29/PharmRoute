# Phase 1: Compliance & Manifest Intelligence - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-04-11
**Phase:** 01-compliance-manifest-intelligence
**Areas discussed:** Extraction & Data Model, Compliance Rules Engine, Frontend UX, Backend Architecture

---

## Extraction & Data Model

### Q1: JSON Schema Depth

| Option | Description | Selected |
|--------|-------------|----------|
| Minimal | Name, CAS number, role, concentration | |
| Standard | Above + INN name, EC number, HS code, scheduling status | |
| Full PRD-aligned | Above + FMD serialisation, DEA schedule, quantity per dose | |
| You decide | Agent picks based on compliance engine needs | ✓ |

**User's choice:** You decide — agent's discretion
**Notes:** Agent should be guided by PRD spec for ingredient-level packing lists

### Q2: Extraction Failure Handling

| Option | Description | Selected |
|--------|-------------|----------|
| Flag and proceed | Extract what's possible, flag low-confidence fields | |
| Block and re-upload | Reject document below confidence threshold | |
| Partial with manual fill | Extract + editable form for user to fill gaps | |
| You decide | Agent picks best approach | ✓ |

**User's choice:** You decide — agent's discretion
**Notes:** Should balance UX with data integrity for hackathon demo

### Q3: Regulatory Seed Data

| Option | Description | Selected |
|--------|-------------|----------|
| WHO Essential Medicines only | Smallest viable set, covers demo | |
| WHO + FDA Orange Book + EU EPAR | Covers both corridors per PRD | |
| Mock/hardcoded dataset | Demo substances only, schema ready for real data | |
| You decide | Agent picks best approach | ✓ |

**User's choice:** You decide — agent's discretion
**Notes:** Must reliably cover Amoxicillin-Clavulanate demo scenario

### Q4: Pinecone vs PostgreSQL for Phase 1

| Option | Description | Selected |
|--------|-------------|----------|
| Pinecone from Phase 1 | Vector embeddings for regulatory PDFs | |
| PostgreSQL only | Exact-match lookups sufficient for MVP | |
| You decide | Agent picks based on actual needs | ✓ |

**User's choice:** You decide — agent's discretion
**Notes:** Exact-match substance lookups may not require vector search

---

## Compliance Rules Engine

### Q1: Rule Structure

| Option | Description | Selected |
|--------|-------------|----------|
| Hardcoded rule functions | One Python module per country with if/else logic | |
| Configurable rule table | Rules in PostgreSQL rows, generic evaluation engine | ✓ |
| You decide | Agent picks | |

**User's choice:** Configurable rule table in PostgreSQL
**Notes:** Data-driven approach, easy to extend to new countries without code changes

### Q2: Remediation Guidance

| Option | Description | Selected |
|--------|-------------|----------|
| Static text | Pre-written guidance strings per rule | |
| Gemini-generated explanations | LLM generates human-readable remediation from failure context | ✓ |
| You decide | Agent picks | |

**User's choice:** Gemini-generated explanations
**Notes:** Stays within "LLM for extraction and explanation" boundary; compliance decision itself remains deterministic

### Q3: Traffic-Light Granularity

| Option | Description | Selected |
|--------|-------------|----------|
| Per-check | Each rule gets its own traffic light | |
| Per-shipment rollup | Single overall status with expandable detail | |
| Both | Rollup at top, per-check breakdown below | ✓ |
| You decide | Agent picks | |

**User's choice:** Both — rollup at top + per-check breakdown
**Notes:** None

---

## Frontend UX

### Q1-Q4: Upload, Progress, HITL, Layout

| Option | Description | Selected |
|--------|-------------|----------|
| All deferred | Agent's discretion on all frontend UX decisions | ✓ |

**User's choice:** You decide for all
**Notes:** Agent should design what best serves the 8-minute hackathon demo flow

---

## Backend Architecture

### Q1: Async Job Implementation

| Option | Description | Selected |
|--------|-------------|----------|
| FastAPI BackgroundTasks | Simple, no extra infra, sufficient for hackathon | ✓ |
| Celery + Redis | Full job queue with retries/monitoring | |
| You decide | Agent picks | |

**User's choice:** FastAPI BackgroundTasks
**Notes:** No external infrastructure needed for single-user hackathon demo

### Q2: Frontend Job Status Updates

| Option | Description | Selected |
|--------|-------------|----------|
| Polling | Frontend polls /status/{job_id} endpoint | |
| Server-Sent Events (SSE) | Backend pushes real-time status updates | ✓ |
| WebSocket | Bidirectional real-time communication | |
| You decide | Agent picks | |

**User's choice:** Server-Sent Events (SSE)
**Notes:** Push-based, simpler than WebSocket, avoids polling overhead

### Q3: API Design Style

| Option | Description | Selected |
|--------|-------------|----------|
| REST | Standard RESTful endpoints | |
| REST + async job pattern | REST for CRUD + /jobs/{id} for long-running ops | ✓ |
| You decide | Agent picks | |

**User's choice:** REST + async job pattern
**Notes:** Standard CRUD plus /jobs/{id} with SSE streaming for document parsing and compliance evaluation

---

## Agent's Discretion

Areas where user deferred to agent judgment:
- Extraction JSON schema depth
- Extraction failure handling UX
- Regulatory seed data strategy
- Pinecone vs PostgreSQL timing
- All frontend UX design choices (upload, progress, HITL, layout)

## Deferred Ideas

None — discussion stayed within phase scope
