# Phase 1: Compliance & Manifest Intelligence - Context

**Gathered:** 2026-04-11
**Status:** Ready for planning

<domain>
## Phase Boundary

Build the core intelligence layer for PharmRoute using an **Elixir/Phoenix** architecture: a Gemini-powered document extraction engine that parses BMRs into structured data, a deterministic compliance rule evaluation system (using Ecto), and a **Phoenix LiveView** frontend for file upload, real-time async status tracking, and traffic-light compliance display. Scope covers India-EU and India-US corridors only.

Requirements in scope: MAN-01, MAN-02, MAN-03, MAN-04, MAN-05, CMP-01, CMP-02, CMP-03, CMP-04, SEC-01

</domain>

<decisions>
## Implementation Decisions

### Technical Stack Pivot
- **D-01:** Framework shifted to **Elixir / Phoenix**.
- **D-02:** Concurrency handled natively via **Erlang VM (OTP)** using `Task` or `GenServer` for background processing.
- **D-03:** Frontend is completely driven by **Phoenix LiveView**. No separate React application, zero REST polling. State changes broadcast over Phoenix PubSub directly to the DOM via WebSockets.

### Extraction & Data Model
- **D-04:** Agent's discretion on JSON schema depth — guided by PRD spec.
- **D-05:** Extraction schema enforcement relies on Gemini JSON mode, called via Elixir HTTP client (`req` or `httpoison`).
- **D-06:** Agent's discretion on regulatory seed data — demo needs Amoxicillin-Clavulanate, India→EU, India→US. 

### Compliance Rules Engine
- **D-07:** rules stored as a **configurable rule table in PostgreSQL** (using Ecto).
- **D-08:** Remediation guidance for failing checks is **Gemini-generated** via HTTP call. Compliance decisions stay purely deterministic.
- **D-09:** Traffic-light display uses **both rollup and per-check granularity**.

### Frontend UX
- **D-10:** Agent's discretion on UI layout, but MUST use **TailwindCSS** and **Phoenix LiveView**. Drag-and-drop file inputs supported via LiveView uploads.

</decisions>

<canonical_refs>
## Canonical References

### Product Requirements
- `PRD.md` / `PRD_extracted.txt` — Full PRD with all 6 modules.
- `.planning/PROJECT.md` — Finalized project context with architecture decisions
- `.planning/REQUIREMENTS.md`

### PRD Demo Scenario
- India → EU Amoxicillin-Clavulanate 625mg (2-8°C cold-stored)
- Nhava Sheva → Rotterdam via Suez Canal
- 8-minute total presentation time
</canonical_refs>

<specifics>
## Specific Ideas
- Phoenix PubSub should be used to broadcast job progress from the background `Task` back to the LiveView process.
</specifics>
