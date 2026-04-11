alias PharmRoute.Repo
alias PharmRoute.Manifest.Substance

substances_data = [
  %{
    name: "Amoxicillin trihydrate",
    cas_number: "61336-70-7",
    inn_name: "amoxicillin",
    ec_number: "262-667-6",
    dea_schedule: nil,
    cdsco_status: "approved",
    is_controlled: false,
    scheduling_notes: %{}
  },
  %{
    name: "Clavulanate potassium",
    cas_number: "61177-45-5",
    inn_name: "clavulanic acid",
    ec_number: "262-503-3",
    dea_schedule: nil,
    cdsco_status: "approved",
    is_controlled: false,
    scheduling_notes: %{}
  },
  %{
    name: "Microcrystalline cellulose",
    cas_number: "9004-34-6",
    inn_name: "cellulose",
    ec_number: "232-674-9",
    dea_schedule: nil,
    cdsco_status: "approved",
    is_controlled: false,
    scheduling_notes: %{}
  },
  %{
    name: "Magnesium stearate",
    cas_number: "557-04-0",
    inn_name: "magnesium stearate",
    ec_number: "209-150-3",
    dea_schedule: nil,
    cdsco_status: "approved",
    is_controlled: false,
    scheduling_notes: %{}
  },
  %{
    name: "Paracetamol",
    cas_number: "103-90-2",
    inn_name: "paracetamol",
    ec_number: "203-157-5",
    dea_schedule: nil,
    cdsco_status: "approved",
    is_controlled: false,
    scheduling_notes: %{}
  },
  %{
    name: "Ibuprofen",
    cas_number: "15687-27-1",
    inn_name: "ibuprofen",
    ec_number: "239-784-6",
    dea_schedule: nil,
    cdsco_status: "approved",
    is_controlled: false,
    scheduling_notes: %{}
  },
  %{
    name: "Oxycodone",
    cas_number: "76-42-6",
    inn_name: "oxycodone",
    ec_number: "200-960-2",
    dea_schedule: "II",
    cdsco_status: "restricted",
    is_controlled: true,
    scheduling_notes: %{"US" => "High potential for abuse", "EU" => "Annex I controlled"}
  },
  %{
    name: "Metformin hydrochloride",
    cas_number: "1115-70-4",
    inn_name: "metformin",
    ec_number: "214-230-6",
    dea_schedule: nil,
    cdsco_status: "approved",
    is_controlled: false,
    scheduling_notes: %{}
  },
  %{
    name: "Diazepam",
    cas_number: "439-14-5",
    inn_name: "diazepam",
    ec_number: "207-122-5",
    dea_schedule: "IV",
    cdsco_status: "restricted",
    is_controlled: true,
    scheduling_notes: %{"US" => "Schedule IV controlled"}
  },
  %{
    name: "Lisinopril",
    cas_number: "83915-83-7",
    inn_name: "lisinopril",
    ec_number: "617-506-6",
    dea_schedule: nil,
    cdsco_status: "approved",
    is_controlled: false,
    scheduling_notes: %{}
  },
  %{
    name: "Simvastatin",
    cas_number: "79902-63-9",
    inn_name: "simvastatin",
    ec_number: "616-751-6",
    dea_schedule: nil,
    cdsco_status: "approved",
    is_controlled: false,
    scheduling_notes: %{}
  },
  %{
    name: "Pseudoephedrine",
    cas_number: "90-82-4",
    inn_name: "pseudoephedrine",
    ec_number: "202-018-6",
    dea_schedule: "Scheduled Listed Chemical",
    cdsco_status: "restricted",
    is_controlled: true,
    scheduling_notes: %{"US" => "Combat Methamphetamine Epidemic Act of 2005"}
  },
  %{
    name: "Aspirin",
    cas_number: "50-78-2",
    inn_name: "acetylsalicylic acid",
    ec_number: "200-064-1",
    dea_schedule: nil,
    cdsco_status: "approved",
    is_controlled: false,
    scheduling_notes: %{}
  },
  %{
    name: "Loperamide",
    cas_number: "53179-11-6",
    inn_name: "loperamide",
    ec_number: "258-410-6",
    dea_schedule: nil,
    cdsco_status: "approved",
    is_controlled: false,
    scheduling_notes: %{}
  }
]

for substance <- substances_data do
  %Substance{}
  |> Substance.changeset(substance)
  |> Repo.insert!(on_conflict: :nothing, conflict_target: :cas_number)
end

IO.puts("Successfully seeded #{length(substances_data)} substances.")

# ──────────────────────────────────────────────
# Compliance Rules
# ──────────────────────────────────────────────
alias PharmRoute.Compliance.Rule

compliance_rules = [
  # ── EU / Netherlands (NLD) Rules ──
  %{
    country_code: "NLD",
    check_type: "substance_control",
    rule_name: "EU Controlled Substance Check",
    description: "Verify no ingredient is on the EU Annex I controlled substances list without proper authorization.",
    condition_field: "is_controlled",
    condition_operator: "is_false",
    condition_value: nil,
    severity: "critical",
    remediation_template: "Controlled substance detected: {substance_name}. Obtain EU Annex I import authorization from the Dutch CIBG before shipping.",
    is_active: true
  },
  %{
    country_code: "NLD",
    check_type: "import_license",
    rule_name: "Dutch Import Drug License",
    description: "All pharmaceutical imports to the Netherlands require a valid Wholesale Distribution Authorization (WDA) under EU GDP guidelines.",
    condition_field: "has_wda_license",
    condition_operator: "is_true",
    condition_value: nil,
    severity: "critical",
    remediation_template: "Missing Wholesale Distribution Authorization (WDA). Apply via the Dutch CIBG portal. Processing: 90 days.",
    is_active: true
  },
  %{
    country_code: "NLD",
    check_type: "serialisation",
    rule_name: "EU FMD Serialisation",
    description: "All prescription medicines entering the EU must carry a unique identifier and anti-tampering device per Falsified Medicines Directive 2011/62/EU.",
    condition_field: "has_fmd_serial",
    condition_operator: "is_true",
    condition_value: nil,
    severity: "critical",
    remediation_template: "FMD serialisation missing. Each unit must have a 2D DataMatrix barcode with GTIN, serial number, batch, and expiry. Register with the EU Medicines Verification System (EMVS).",
    is_active: true
  },
  %{
    country_code: "NLD",
    check_type: "temperature",
    rule_name: "EU GDP Cold Chain Compliance",
    description: "Temperature-sensitive APIs must maintain 2–8°C during transit per EU Good Distribution Practice guidelines (2013/C 343/01).",
    condition_field: "requires_cold_chain",
    condition_operator: "is_false",
    condition_value: nil,
    severity: "warning",
    remediation_template: "Cold chain required but not confirmed. Ensure qualified packaging with continuous temperature monitoring and GDP-compliant logistics partner.",
    is_active: true
  },
  %{
    country_code: "NLD",
    check_type: "documentation",
    rule_name: "EU GMP Certificate",
    description: "Active substances imported into the EU must be accompanied by a written confirmation from the competent authority of the exporting country (EU Directive 2001/83/EC, Art. 46b).",
    condition_field: "has_gmp_certificate",
    condition_operator: "is_true",
    condition_value: nil,
    severity: "critical",
    remediation_template: "GMP certificate from exporting country required. For India, obtain a Written Confirmation from CDSCO confirming GMP equivalence with EU standards.",
    is_active: true
  },
  %{
    country_code: "NLD",
    check_type: "documentation",
    rule_name: "EU Certificate of Suitability (CEP)",
    description: "APIs must have a valid CEP from EDQM confirming compliance with the European Pharmacopoeia monograph.",
    condition_field: "has_cep",
    condition_operator: "is_true",
    condition_value: nil,
    severity: "warning",
    remediation_template: "No CEP found. Apply to EDQM for a Certificate of Suitability, or ensure the Marketing Authorization Holder's dossier includes an ASMF (Active Substance Master File).",
    is_active: true
  },

  # ── US (USA) Rules ──
  %{
    country_code: "USA",
    check_type: "substance_control",
    rule_name: "DEA Schedule Check",
    description: "Verify ingredient is not a DEA scheduled substance (Schedules I-V) requiring DEA Form 236 import permit.",
    condition_field: "dea_schedule",
    condition_operator: "not_exists",
    condition_value: nil,
    severity: "critical",
    remediation_template: "DEA controlled substance detected: {substance_name} (Schedule {dea_schedule}). File DEA Form 236 import permit minimum 15 business days before shipment.",
    is_active: true
  },
  %{
    country_code: "USA",
    check_type: "import_alert",
    rule_name: "FDA Import Alert Check",
    description: "Verify manufacturer is not subject to an active FDA Import Alert (Detention Without Physical Examination).",
    condition_field: "has_fda_import_alert",
    condition_operator: "is_false",
    condition_value: nil,
    severity: "critical",
    remediation_template: "Manufacturer may be on FDA Import Alert list. Check FDA Import Alert #66-40 for pharmaceutical ingredients. Resolve by submitting evidence of cGMP compliance to the FDA district.",
    is_active: true
  },
  %{
    country_code: "USA",
    check_type: "documentation",
    rule_name: "FDA Drug Master File",
    description: "APIs imported to the US should have an active Type II Drug Master File (DMF) on file with the FDA.",
    condition_field: "has_dmf",
    condition_operator: "is_true",
    condition_value: nil,
    severity: "warning",
    remediation_template: "No active DMF found. The API manufacturer must file a Type II DMF with the FDA. Processing time: 4-6 months. Alternatively, reference an existing DMF holder.",
    is_active: true
  },
  %{
    country_code: "USA",
    check_type: "temperature",
    rule_name: "USP Cold Chain Compliance",
    description: "Temperature-sensitive pharmaceuticals must comply with USP <1079> Good Storage and Distribution Practices.",
    condition_field: "requires_cold_chain",
    condition_operator: "is_false",
    condition_value: nil,
    severity: "warning",
    remediation_template: "Cold chain compliance required per USP <1079>. Ensure continuous temperature monitoring with calibrated data loggers and qualified shipping lanes.",
    is_active: true
  },

  # ── India (IND) Export Rules ──
  %{
    country_code: "IND",
    check_type: "export_license",
    rule_name: "CDSCO Export NOC",
    description: "Pharmaceutical exports from India require a No Objection Certificate (NOC) from CDSCO for each shipment batch.",
    condition_field: "has_export_noc",
    condition_operator: "is_true",
    condition_value: nil,
    severity: "critical",
    remediation_template: "CDSCO Export NOC required. Apply via the SUGAM portal (https://sugam.cdsco.gov.in). Typical processing: 7-15 business days.",
    is_active: true
  },
  %{
    country_code: "IND",
    check_type: "documentation",
    rule_name: "Certificate of Pharmaceutical Product (CoPP)",
    description: "WHO-type Certificate of Pharmaceutical Product required for export under the WHO Certification Scheme.",
    condition_field: "has_copp",
    condition_operator: "is_true",
    condition_value: nil,
    severity: "critical",
    remediation_template: "CoPP missing. Apply to CDSCO via the SUGAM portal. The CoPP certifies the product is authorized for sale in India and manufactured under GMP.",
    is_active: true
  }
]

for rule_attrs <- compliance_rules do
  %Rule{}
  |> Rule.changeset(rule_attrs)
  |> Repo.insert!(on_conflict: :nothing)
end

IO.puts("Successfully seeded #{length(compliance_rules)} compliance rules.")
