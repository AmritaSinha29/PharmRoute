defmodule PharmRoute.Manifest.Substance do
  use Ecto.Schema
  import Ecto.Changeset

  schema "substances" do
    field :cas_number, :string
    field :cdsco_status, :string
    field :dea_schedule, :string
    field :ec_number, :string
    field :inn_name, :string
    field :is_controlled, :boolean, default: false
    field :name, :string
    field :scheduling_notes, :map

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(substance, attrs) do
    substance
    |> cast(attrs, [:name, :cas_number, :inn_name, :ec_number, :dea_schedule, :cdsco_status, :is_controlled, :scheduling_notes])
    |> validate_required([:name, :cas_number, :inn_name, :ec_number, :dea_schedule, :cdsco_status, :is_controlled])
    |> unique_constraint(:cas_number)
  end
end
