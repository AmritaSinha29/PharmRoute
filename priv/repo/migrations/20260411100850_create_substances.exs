defmodule PharmRoute.Repo.Migrations.CreateSubstances do
  use Ecto.Migration

  def change do
    create table(:substances) do
      add :name, :string
      add :cas_number, :string
      add :inn_name, :string
      add :ec_number, :string
      add :dea_schedule, :string
      add :cdsco_status, :string
      add :is_controlled, :boolean, default: false, null: false
      add :scheduling_notes, :map

      timestamps(type: :utc_datetime)
    end

    create unique_index(:substances, [:cas_number])
  end
end
