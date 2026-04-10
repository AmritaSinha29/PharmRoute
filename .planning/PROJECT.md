# PharmRoute

## What This Is

PharmRoute is an AI-powered export intelligence platform purpose-built for pharmaceutical companies exporting from India. It provides intelligent document generation, country-specific compliance validation, real-time route optimization, and proactive disruption detection.

## Core Value

Ensure every pharmaceutical export shipment meets destination-country regulations, maintains cold-chain integrity, and reaches the buyer on time, eliminating customs rejections and costly delays.

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] **MANIFEST-01**: Parse batch manufacturing records and generate compliant ingredient-level packing lists
- [ ] **COMPL-01**: Validate shipments against destination drug scheduling and permit rules
- [ ] **ROUTE-01**: Score multi-modal routes on time, cost, cold-chain capability, and regulatory risk
- [ ] **ALERT-01**: Monitor active shipments for disruptions and auto-generate constraint-aware rerouting options
- [ ] **DEMO-01**: Provide a pre-built simulation environment (Suez Canal congestion) for the hackathon presentation

### Out of Scope

- Full ERP integration — Hackathon build uses manual file upload instead.
- Real payments / Letter of Credit execution — Too complex for the MVP.
- Physical IoT cold chain sensors — Simulated data used for the demo.
- Freight booking execution — Rerouting is recommended, not actively booked.
- Multi-language localization — English only for the hackathon.

## Context

Typical pharma exporters use manual packing lists that gloss over APIs and lack predictive route monitoring, leading to FDA/EU import rejections or cold-chain breaches.
- Project targets the Google Hackathon 2025 (Smart Supply Chains track)
- Uses Gemini 1.5 Pro, text-embedding-004, and Google Maps Platform
- Backend: FastAPI, Postgres, Pinecone
- Frontend: React + TypeScript

## Constraints

- **Time**: Hackathon timeline (3 weeks) — MVP must cleanly execute an edge-case disruption demo within 8 minutes.
- **Tech Stack**: Must heavily leverage Google's AI capabilities (Gemini, text-embedding, Cloud Run, Search Grounding) to meet evaluation criteria.
- **Reliability**: Generative AI cannot hallucinate regulatory facts; it must be grounded in exact-match chemical lookups and authoritative DBs.
- **Scope**: Build only P0 features (Manifest Engine, Compliance Dashboard, Route Scoring, Disruption Detection, Demo Scenario).

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Exclude physical IoT in demo | De-risk hardware failure during an 8-min presentation | — Pending |
| Use exact-match lookup for substance matching | Prevent LLM hallucination of regulatory facts | — Pending |
| Limit MVP to India-EU and India-US corridors | Focus on highest-value, strictest compliance regions for maximum impact | — Pending |

---
*Last updated: 2026-04-11 after initialization*
