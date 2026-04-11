defmodule PharmRoute.Manifest.Shipment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "shipments" do
    field :destination_country, :string
    field :extracted_data, :map
    field :product_name, :string
    field :status, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(shipment, attrs) do
    shipment
    |> cast(attrs, [:product_name, :destination_country, :extracted_data, :status])
    |> validate_required([:product_name, :destination_country, :status])
  end
end
