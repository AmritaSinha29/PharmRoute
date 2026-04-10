# Roadmap: PharmRoute

## Overview

The journey to building PharmRoute for the Google Hackathon. We start by building the core intelligence layer (Manifest and Compliance), follow it up with the real-time routing and disruption simulation, and finalize by assembling the end-to-end presentation demo scenario.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

- [ ] **Phase 1: Compliance & Manifest Intelligence** - Extract substance data and validate destination-specific rules.
- [ ] **Phase 2: Route Scoring & Disruption Engine** - Evaluate and reroute shipments based on compliance and cold-chain constraints.
- [ ] **Phase 3: End-to-End Demo Integration** - Assemble the UI and the simulated scenario for Hackathon Demo Day.

## Phase Details

### Phase 1: Compliance & Manifest Intelligence
**Goal**: Build the knowledge base and document extraction engine capable of identifying and structuring pharma ingredients securely.
**Depends on**: Nothing
**Requirements**: [MAN-01, MAN-02, MAN-03, CMP-01, CMP-02, CMP-03]
**Success Criteria** (what must be TRUE):
  1. System extracts API and excipients from a sample PDF without hallucination.
  2. System generates a valid mock packing list matching strict EU/US requirements.
  3. Traffic-light dashboard correctly flags missing compliance for a given shipment and destination.
**Plans**: 3 plans

Plans:
- [ ] 01-01: Set up vector DB and FastAPI backend with Gemini extraction prompts
- [ ] 01-02: Build the compliance rule evaluation logic
- [ ] 01-03: Implement the basic React frontend for file upload and status display

### Phase 2: Route Scoring & Disruption Engine
**Goal**: Evaluate logistical routes dynamically against hard constraints and construct a detection layer for interruptions.
**Depends on**: Phase 1
**Requirements**: [RTE-01, RTE-02, RTE-03, RTE-04]
**Success Criteria** (what must be TRUE):
  1. System scores a set of mock routes across cost, time, regulatory risk, and cold-chain suitability.
  2. Disruption trigger successfully forces a re-evaluation of routes.
  3. System provides an automatically generated recommendation prioritizing compliance over transit time if needed.
**Plans**: 3 plans

Plans:
- [ ] 02-01: Build the route constraint scoring function
- [ ] 02-02: Implement the disruption simulator endpoint
- [ ] 02-03: Construct the reroute recommendation UI

### Phase 3: End-to-End Demo Integration
**Goal**: Polish the user flow for an 8-minute hackathon pitch with the targeted India-to-EU scenario.
**Depends on**: Phase 2
**Requirements**: [DEMO-01, DEMO-02, DEMO-03]
**Success Criteria** (what must be TRUE):
  1. Operator can walk through the entire flow (upload -> compliance check -> disrupt -> reroute) smoothly.
  2. The final impact dashboard correctly displays simulated savings (financial and regulatory value).
  3. UI looks polished and professional using standard React components.
**Plans**: 3 plans

Plans:
- [ ] 03-01: Wire the simulated Suez traffic delay feed
- [ ] 03-02: Polish the UI dashboard and impact summaries
- [ ] 03-03: Run end-to-end tests against the 8-minute pitch limit

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Compliance & Manifest Intelligence | 0/3 | Not started | - |
| 2. Route Scoring & Disruption Engine | 0/3 | Not started | - |
| 3. End-to-End Demo Integration | 0/3 | Not started | - |
