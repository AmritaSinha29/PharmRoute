# Phase 1: Compliance & Manifest Intelligence - Context

**Gathered:** 2026-04-11
**Status:** Ready for planning

<domain>
## Phase Boundary

Build the core intelligence layer for PharmRoute: a Gemini-powered document extraction engine that parses batch manufacturing records into structured ingredient data, a deterministic compliance rule evaluation system that validates shipments against destination-country regulations, and a React frontend for file upload, async status tracking, and traffic-light compliance display. Scope covers India-EU and India-US corridors only.

Requirements in scope: MAN-01, MAN-02, MAN-03, MAN-04, MAN-05, CMP-01, CMP-02, CMP-03, CMP-04, SEC-01

</domain>

<decisions>
## Implementation Decisions

### Extraction & Data Model
- **D-01:** Agent's discretion on JSON schema depth — should be guided by PRD spec (ingredient-level packing lists with regulatory identifiers per destination country). Schema must support at minimum: substance name, CAS number, role (API/excipient/controlled), and destination-specific regulatory fields needed by the compliance engine.
- **D-02:** Agent's discretion on extraction failure handling — choose the approach that best balances user experience with data integrity for the hackathon demo.
- **D-03:** Agent's discretion on regulatory seed data — choose the approach that reliably covers the demo scenario (Amoxicillin-Clavulanate, India→EU, India→US) while keeping the schema extensible.
- **D-04:** Agent's discretion on Pinecone vs PostgreSQL-only for Phase 1 — exact-match substance lookups may not require vector search; decide based on what the compliance engine actually needs.

### Compliance Rules Engine
- **D-05:** Compliance rules stored as a **configurable rule table in PostgreSQL** — a generic evaluation engine reads rule rows (country, check_type, threshold, remediation_template) rather than hardcoded per-country Python modules. This keeps rules data-driven and easy to extend.
- **D-06:** Remediation guidance for failing checks is **Gemini-generated** — when a compliance check fails, LLM generates a human-readable explanation of why it failed and what the user should do to fix it. This stays within the "LLM for extraction and explanation only" architecture decision. The compliance *decision* itself remains deterministic.
- **D-07:** Traffic-light display uses **both rollup and per-check granularity** — shipment-level summary status (red/amber/green) shown at the top, with an expandable per-check breakdown below showing individual rule results.

### Frontend UX
- **D-08:** Agent's discretion on all frontend UX decisions — file upload mechanism, async progress display, HITL confirmation screen layout, and overall page structure (dashboard vs wizard). Agent should design what best serves the 8-minute hackathon demo flow.

### Backend Architecture
- **D-09:** Async background jobs use **FastAPI BackgroundTasks** — no external job queue infrastructure (no Celery/Redis) for hackathon MVP. Sufficient for single-user demo scale.
- **D-10:** Frontend receives job status updates via **Server-Sent Events (SSE)** — backend pushes real-time status updates. Simpler than WebSocket, avoids polling overhead.
- **D-11:** API design follows **REST + async job pattern** — standard RESTful endpoints for CRUD operations, plus a `/jobs/{id}` pattern with SSE streaming for long-running operations (document parsing, compliance evaluation).

### Agent's Discretion
The user deferred multiple technical decisions to agent judgment. For these items, the agent has flexibility to choose the best approach, guided by:
- The PRD (PRD_extracted.txt) as the primary source of truth
- The architecture decisions in PROJECT.md (hybrid AI/deterministic, async processing, HITL before export only, zero training-data retention)
- Hackathon demo viability (8-minute flow, single operator, India→EU scenario)

Areas of full agent discretion: extraction JSON schema depth, extraction failure UX, regulatory seed data strategy, Pinecone timing, and all frontend UX design choices.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Product Requirements
- `PRD.md` (Word document) — Full PRD with all 6 modules, demo flow, technical architecture, and success metrics. Extract text via the `PRD_extracted.txt` file.
- `PRD_extracted.txt` — Plain-text extraction of the PRD for agent consumption
- `.planning/PROJECT.md` — Finalized project context with architecture decisions
- `.planning/REQUIREMENTS.md` — v1 requirements with traceability matrix
- `.planning/ROADMAP.md` — Phase breakdown and success criteria

### Architecture Decisions (embedded in PROJECT.md)
- Hybrid AI/Deterministic Pipeline — LLM for extraction only, deterministic compliance
- Async Processing — BackgroundTasks + SSE
- HITL — Before final export only
- Data Security — Zero training-data retention

### PRD Demo Scenario (Section 7)
- India → EU Amoxicillin-Clavulanate 625mg (2-8°C cold-stored)
- Nhava Sheva → Rotterdam via Suez Canal
- 5-step demo flow: manifest → compliance → route → disruption → impact summary
- 8-minute total presentation time

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- None — greenfield project, no existing codebase

### Established Patterns
- None yet — Phase 1 establishes the foundational patterns

### Integration Points
- FastAPI backend will serve as the API layer for all subsequent phases
- PostgreSQL rule table schema established here will be extended in Phase 2 (route constraints)
- React frontend component patterns (upload, dashboard, status) will be reused in Phases 2 and 3
- SSE job status pattern will be reused for route scoring in Phase 2

</code_context>

<specifics>
## Specific Ideas

- Compliance rule table must be configurable enough to add new countries/rules without code changes
- Gemini remediation text should explain the "why" and "how to fix" — not just restate the rule name
- The demo scenario substances (Amoxicillin trihydrate, Clavulanate potassium, microcrystalline cellulose, magnesium stearate) must work flawlessly in the extraction + compliance pipeline
- SSE status updates should feel responsive — user should see progress within seconds, not wait in silence

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 01-compliance-manifest-intelligence*
*Context gathered: 2026-04-11*
