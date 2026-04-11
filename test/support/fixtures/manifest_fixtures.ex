defmodule PharmRoute.ManifestFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PharmRoute.Manifest` context.
  """

  @doc """
  Generate a unique substance cas_number.
  """
  def unique_substance_cas_number, do: "some cas_number#{System.unique_integer([:positive])}"

  @doc """
  Generate a substance.
  """
  def substance_fixture(attrs \\ %{}) do
    {:ok, substance} =
      attrs
      |> Enum.into(%{
        cas_number: unique_substance_cas_number(),
        cdsco_status: "some cdsco_status",
        dea_schedule: "some dea_schedule",
        ec_number: "some ec_number",
        inn_name: "some inn_name",
        is_controlled: true,
        name: "some name",
        scheduling_notes: %{}
      })
      |> PharmRoute.Manifest.create_substance()

    substance
  end

  @doc """
  Generate a shipment.
  """
  def shipment_fixture(attrs \\ %{}) do
    {:ok, shipment} =
      attrs
      |> Enum.into(%{
        destination_country: "some destination_country",
        extracted_data: %{},
        product_name: "some product_name",
        status: "some status"
      })
      |> PharmRoute.Manifest.create_shipment()

    shipment
  end
end
