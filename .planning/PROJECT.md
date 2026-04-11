# PharmRoute

## What This Is

PharmRoute is an AI-powered export intelligence platform purpose-built for pharmaceutical companies exporting from India. It provides intelligent document generation, country-specific compliance validation, real-time route optimization, and proactive disruption detection — addressing the full lifecycle of a pharma shipment from batch manufacturing record to import clearance.

## Core Value

Ensure every pharmaceutical export shipment meets destination-country regulations, maintains cold-chain integrity, and reaches the buyer on time — eliminating customs rejections, cold-chain breaches, and costly delays.

## Core Insight

Every existing logistics tool treats a pharma shipment like a box of electronics. PharmRoute treats it like what it actually is: a regulated medical product with a chain of custody that must be legally traceable from batch manufacturing record to import clearance. The intelligence difference is not in the routing algorithm — it is in the constraint layer that wraps around every routing decision.

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] **MAN-01**: Parse batch manufacturing records and generate compliant ingredient-level packing lists per destination country
- [ ] **MAN-02**: Extract APIs, excipients, and controlled substances accurately using Gemini (structured JSON extraction only)
- [ ] **MAN-03**: Generate destination-specific packing lists with regulatory identifiers (EC numbers, FMD barcodes, DEA schedule mappings)
- [ ] **MAN-04**: Human-in-the-Loop (HITL) confirmation required before final document export — user explicitly confirms LLM extractions
- [ ] **MAN-05**: Async document parsing with loading states and background job status updates in the UI
- [ ] **CMP-01**: Validate shipments against destination-country drug scheduling and permit rules (deterministic/rule-based — no LLM)
- [ ] **CMP-02**: Traffic-light compliance dashboard with specific remediation guidance for each failing check
- [ ] **CMP-03**: Hybrid pipeline — LLM extracts structured JSON, backend deterministic logic independently handles compliance decisions
- [ ] **RTE-01**: Score multi-modal routes on time, cost, cold-chain capability, and regulatory risk
- [ ] **RTE-02**: Async route scoring as background jobs with UI status updates
- [ ] **ALT-01**: Monitor active shipments for disruptions and auto-generate constraint-aware rerouting options
- [ ] **DEMO-01**: Pre-built India-to-EU Amoxicillin-Clavulanate simulation (Suez Canal congestion scenario)
- [ ] **SEC-01**: Zero training-data retention — strict handling of sensitive pharma/export documents (BMRs, regulatory filings)

### Out of Scope

- Full ERP integration — Hackathon build uses manual file upload instead.
- Real payments / Letter of Credit execution — Too complex for the MVP.
- Physical IoT cold chain sensors — Simulated data used for the demo.
- Freight booking execution — Rerouting is recommended, not actively booked.
- Multi-language localization — English only for the hackathon.
- Stakeholder Coordination Hub — P1 feature, not for hackathon MVP.
- Regulatory Radar (continuous monitoring) — P1 feature.
- Cold Chain Monitor (real-time IoT tracking) — P1 feature.
- Document Generator (shipping bill, invoice, CoA, MSDS, BL) — P1 feature.

## Context

India is the world's largest supplier of generic medicines (~20% of global generic drug exports by volume). Yet export operations remain manual, fragmented, and compliance-blind — mislabelled substances, undisclosed APIs, or cold-chain failures cause shipment seizures, regulatory blacklisting, and multi-crore losses.

- **Target:** Google Hackathon 2025 (Smart Supply Chains track)
- **Timeline:** 3 weeks — MVP must cleanly execute an edge-case disruption demo within 8 minutes
- **Demo Scenario:** India → EU Amoxicillin-Clavulanate shipment hit by simulated Suez Canal congestion
- **Focus corridors:** India-EU and India-US (highest-value, strictest compliance)

### Target Users

| Role | Need |
|------|------|
| Export Manager | Compliance confidence and route visibility without manual research |
| Regulatory Affairs Lead | Systematic pre-shipment checks against destination-country rules |
| CHA / Freight Agent | Clean, validated inputs to avoid customs discrepancies |
| Supply Chain Director | Predictive disruption alerts and alternative scenario modelling |

## Architecture Decisions

### Hybrid AI/Deterministic Pipeline

| Layer | Role | Technology |
|-------|------|------------|
| **Extraction** | Parse BMRs, structure ingredient data, generate explanations | Gemini 1.5 Pro (JSON mode) |
| **Compliance** | All regulatory decisions — scheduling checks, permit validation, substance matching | Deterministic rules + exact-match DB lookups (NO LLM) |
| **Routing** | Score and rank routes against multi-dimensional constraints | Deterministic scoring with weighted graph |

### Async & Real-time Processing (Elixir/OTP)

- **Fault-Tolerant Concurrency:** Document parsing and route scoring run as isolated Erlang VM processes (Task/GenServer). If processing crashes, the core system stays up.
- **Real-time UX:** Phoenix LiveView pushes state changes directly to the browser DOM over WebSockets. No manual polling, SSE, or separate frontend state management is required.
- Frontend never blocks, providing an enterprise-grade, highly reactive experience.

### Human-in-the-Loop (HITL)

- Required **before final document export only**
- User explicitly confirms LLM-extracted APIs/excipients before the packing list is finalized
- NOT required for intermediate steps (compliance checks, route scoring happen automatically)

### Data Security

- Zero training-data retention policy for all parsed documents
- Strict privacy handling for BMRs, regulatory filings, and export documentation
- No user data used for model training

## Tech Stack

| Component | Technology |
|-----------|------------|
| **Core Platform** | Elixir (Phoenix Framework) — Fault-tolerant backend, AI orchestration, rules engine |
| **Realtime UI** | Phoenix LiveView + TailwindCSS — Server-rendered DOM updates over WebSockets |
| **AI Core** | Gemini 1.5 Pro (extraction), text-embedding-004 (regulatory search), Google Search grounding |
| **Maps** | Google Maps Platform — route visualization, port/facility mapping |
| **Database** | PostgreSQL (shipment data) + Pinecone (regulatory vector store) |
| **Hosting** | Google Cloud Run — serverless, auto-scaling |

## Key Decisions

| Decision | Rationale | Status |
|----------|-----------|--------|
| HITL before final export only | Balances safety with UX — intermediate steps run automatically | ✅ Decided |
| LLM for extraction only, deterministic compliance | Prevents hallucination of regulatory facts — exact-match lookups for substance ID | ✅ Decided |
| Async document parsing + route scoring | Unblocks frontend, handles latency of AI operations gracefully | ✅ Decided |
| Zero training-data retention | Strict pharma data privacy — BMRs contain proprietary formulations | ✅ Decided |
| Exact-match substance lookup (CAS, INN) | Prevents LLM hallucination of regulatory facts | ✅ Decided |
| Limit MVP to India-EU and India-US | Focus on highest-value, strictest compliance corridors for maximum impact | ✅ Decided |
| Exclude physical IoT in demo | De-risk hardware failure during 8-min presentation — use simulated data | ✅ Decided |
| P0 features only for hackathon | Strict scope control — Modules 4/5/6 are P1/P2, not for MVP | ✅ Decided |

---
*Last updated: 2026-04-11 — finalized with user architecture decisions*
