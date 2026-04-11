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
