defmodule PharmRoute.Repo.Migrations.CreateComplianceRules do
  use Ecto.Migration

  def change do
    create table(:compliance_rules) do
      add :country_code, :string, size: 3, null: false
      add :check_type, :string, null: false
      add :rule_name, :string, null: false
      add :description, :text
      add :condition_field, :string, null: false
      add :condition_operator, :string, null: false
      add :condition_value, :text
      add :severity, :string, null: false, default: "critical"
      add :remediation_template, :text
      add :is_active, :boolean, default: true, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:compliance_rules, [:country_code])
    create index(:compliance_rules, [:is_active])
  end
end
