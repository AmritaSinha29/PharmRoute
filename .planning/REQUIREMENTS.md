# Requirements: PharmRoute

**Defined:** 2026-04-11
**Core Value:** Ensure every pharmaceutical export shipment meets destination-country regulations, maintains cold-chain integrity, and reaches the buyer on time, eliminating customs rejections and costly delays.

## v1 Requirements

### Box Manifest Engine
- [ ] **MAN-01**: User can upload batch manufacturing record PDFs
- [ ] **MAN-02**: System extracts APIs, excipients, and controlled substances accurately
- [ ] **MAN-03**: System generates destination-specific, ingredient-level packing lists including regulatory identifiers (e.g., EC numbers, FMD barcodes)

### Compliance Checker
- [ ] **CMP-01**: System checks product against destination country scheduling rules
- [ ] **CMP-02**: System validates if specific buyer permits/licenses are required
- [ ] **CMP-03**: Dashboard displays a traffic-light status with remediation guidance for failing checks

### Route & Disruption Intelligence
- [ ] **RTE-01**: System scores available transit routes based on time, cost, cold-chain persistence, and regulatory risk
- [ ] **RTE-02**: Disruption engine ingests transit signals (simulated vessel delays, port congestion)
- [ ] **RTE-03**: System detects active disruptions and alerts the user within 15 minutes of anomaly detection
- [ ] **RTE-04**: System auto-generates 3 alternate routing plans preserving cold-chain and compliance rules

### Hackathon Demo Scenario
- [ ] **DEMO-01**: Pre-scripted India-to-EU Amoxicillin-Clavulanate shipment with cold-chain needs
- [ ] **DEMO-02**: Trigger simulated Suez Canal disruption cleanly during the presentation
- [ ] **DEMO-03**: Demonstrate end-to-end impact summary highlighting INR value protected by the AI intervention

## v2 Requirements

### Analytics & Expansion
- **DOC-01**: Auto-generate shipping bill, commercial invoice, CoA, MSDS, and BL
- **COLD-01**: Integrate Live IoT tracking across all logistics nodes with predictive excursion alerting
- **RADAR-01**: NLP-driven continuous regulatory monitoring across 50+ markets globally
- **HUB-01**: Shared workspace feature across Exporter, CHA, Forwarder, and Buyer with LC discrepancy checking
- **ERP-01**: Direct integration into SAP, Oracle, and Tally
- **EXP-01**: Expand constraint layer to secondary markets like hazardous chemicals

## Out of Scope

| Feature | Reason |
|---------|--------|
| Multi-language localization | Not required for initial Hackathon judging |
| Live booking execution | API integrations to carriers are too volatile/time-consuming |
| Physical IoT hardware | Mitigating presentation risks; relying on simulation for demo |
| Real payment / LC clearing | Financial API overhead deemed P2 priority |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| MAN-01 | Phase 1 | Pending |
| MAN-02 | Phase 1 | Pending |
| MAN-03 | Phase 1 | Pending |
| CMP-01 | Phase 1 | Pending |
| CMP-02 | Phase 1 | Pending |
| CMP-03 | Phase 1 | Pending |
| RTE-01 | Phase 2 | Pending |
| RTE-02 | Phase 2 | Pending |
| RTE-03 | Phase 2 | Pending |
| RTE-04 | Phase 2 | Pending |
| DEMO-01 | Phase 3 | Pending |
| DEMO-02 | Phase 3 | Pending |
| DEMO-03 | Phase 3 | Pending |

**Coverage:**
- v1 requirements: 13 total
- Mapped to phases: 13
- Unmapped: 0 ✓

---
*Requirements defined: 2026-04-11*
*Last updated: 2026-04-11 after initial definition*
