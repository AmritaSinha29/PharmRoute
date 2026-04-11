defmodule PharmRoute.Compliance.Rule do
  @moduledoc """
  Ecto schema for deterministic compliance rules.

  Each rule defines a single regulatory check for a specific country corridor.
  Rules are evaluated deterministically — the LLM is never used for pass/fail decisions,
  only for generating human-readable remediation text when a check fails.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "compliance_rules" do
    field :country_code, :string
    field :check_type, :string
    field :rule_name, :string
    field :description, :string
    field :condition_field, :string
    field :condition_operator, :string
    field :condition_value, :string
    field :severity, :string, default: "critical"
    field :remediation_template, :string
    field :is_active, :boolean, default: true

    timestamps(type: :utc_datetime)
  end

  @required_fields ~w(country_code check_type rule_name condition_field condition_operator severity)a
  @optional_fields ~w(description condition_value remediation_template is_active)a

  @doc false
  def changeset(rule, attrs) do
    rule
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:severity, ["critical", "warning", "info"])
    |> validate_inclusion(:condition_operator, [
      "equals",
      "not_equals",
      "contains",
      "not_contains",
      "greater_than",
      "less_than",
      "in_list",
      "not_in_list",
      "is_true",
      "is_false",
      "exists",
      "not_exists"
    ])
  end
end
