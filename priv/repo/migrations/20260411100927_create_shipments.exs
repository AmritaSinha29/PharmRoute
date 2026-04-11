defmodule PharmRoute.Repo.Migrations.CreateShipments do
  use Ecto.Migration

  def change do
    create table(:shipments) do
      add :product_name, :string
      add :destination_country, :string
      add :extracted_data, :map
      add :status, :string

      timestamps(type: :utc_datetime)
    end
  end
end
