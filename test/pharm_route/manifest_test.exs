defmodule PharmRoute.ManifestTest do
  use PharmRoute.DataCase

  alias PharmRoute.Manifest

  describe "substances" do
    alias PharmRoute.Manifest.Substance

    import PharmRoute.ManifestFixtures

    @invalid_attrs %{cas_number: nil, cdsco_status: nil, dea_schedule: nil, ec_number: nil, inn_name: nil, is_controlled: nil, name: nil, scheduling_notes: nil}

    test "list_substances/0 returns all substances" do
      substance = substance_fixture()
      assert Manifest.list_substances() == [substance]
    end

    test "get_substance!/1 returns the substance with given id" do
      substance = substance_fixture()
      assert Manifest.get_substance!(substance.id) == substance
    end

    test "create_substance/1 with valid data creates a substance" do
      valid_attrs = %{cas_number: "some cas_number", cdsco_status: "some cdsco_status", dea_schedule: "some dea_schedule", ec_number: "some ec_number", inn_name: "some inn_name", is_controlled: true, name: "some name", scheduling_notes: %{}}

      assert {:ok, %Substance{} = substance} = Manifest.create_substance(valid_attrs)
      assert substance.cas_number == "some cas_number"
      assert substance.cdsco_status == "some cdsco_status"
      assert substance.dea_schedule == "some dea_schedule"
      assert substance.ec_number == "some ec_number"
      assert substance.inn_name == "some inn_name"
      assert substance.is_controlled == true
      assert substance.name == "some name"
      assert substance.scheduling_notes == %{}
    end

    test "create_substance/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Manifest.create_substance(@invalid_attrs)
    end

    test "update_substance/2 with valid data updates the substance" do
      substance = substance_fixture()
      update_attrs = %{cas_number: "some updated cas_number", cdsco_status: "some updated cdsco_status", dea_schedule: "some updated dea_schedule", ec_number: "some updated ec_number", inn_name: "some updated inn_name", is_controlled: false, name: "some updated name", scheduling_notes: %{}}

      assert {:ok, %Substance{} = substance} = Manifest.update_substance(substance, update_attrs)
      assert substance.cas_number == "some updated cas_number"
      assert substance.cdsco_status == "some updated cdsco_status"
      assert substance.dea_schedule == "some updated dea_schedule"
      assert substance.ec_number == "some updated ec_number"
      assert substance.inn_name == "some updated inn_name"
      assert substance.is_controlled == false
      assert substance.name == "some updated name"
      assert substance.scheduling_notes == %{}
    end

    test "update_substance/2 with invalid data returns error changeset" do
      substance = substance_fixture()
      assert {:error, %Ecto.Changeset{}} = Manifest.update_substance(substance, @invalid_attrs)
      assert substance == Manifest.get_substance!(substance.id)
    end

    test "delete_substance/1 deletes the substance" do
      substance = substance_fixture()
      assert {:ok, %Substance{}} = Manifest.delete_substance(substance)
      assert_raise Ecto.NoResultsError, fn -> Manifest.get_substance!(substance.id) end
    end

    test "change_substance/1 returns a substance changeset" do
      substance = substance_fixture()
      assert %Ecto.Changeset{} = Manifest.change_substance(substance)
    end
  end

  describe "shipments" do
    alias PharmRoute.Manifest.Shipment

    import PharmRoute.ManifestFixtures

    @invalid_attrs %{destination_country: nil, extracted_data: nil, product_name: nil, status: nil}

    test "list_shipments/0 returns all shipments" do
      shipment = shipment_fixture()
      assert Manifest.list_shipments() == [shipment]
    end

    test "get_shipment!/1 returns the shipment with given id" do
      shipment = shipment_fixture()
      assert Manifest.get_shipment!(shipment.id) == shipment
    end

    test "create_shipment/1 with valid data creates a shipment" do
      valid_attrs = %{destination_country: "some destination_country", extracted_data: %{}, product_name: "some product_name", status: "some status"}

      assert {:ok, %Shipment{} = shipment} = Manifest.create_shipment(valid_attrs)
      assert shipment.destination_country == "some destination_country"
      assert shipment.extracted_data == %{}
      assert shipment.product_name == "some product_name"
      assert shipment.status == "some status"
    end

    test "create_shipment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Manifest.create_shipment(@invalid_attrs)
    end

    test "update_shipment/2 with valid data updates the shipment" do
      shipment = shipment_fixture()
      update_attrs = %{destination_country: "some updated destination_country", extracted_data: %{}, product_name: "some updated product_name", status: "some updated status"}

      assert {:ok, %Shipment{} = shipment} = Manifest.update_shipment(shipment, update_attrs)
      assert shipment.destination_country == "some updated destination_country"
      assert shipment.extracted_data == %{}
      assert shipment.product_name == "some updated product_name"
      assert shipment.status == "some updated status"
    end

    test "update_shipment/2 with invalid data returns error changeset" do
      shipment = shipment_fixture()
      assert {:error, %Ecto.Changeset{}} = Manifest.update_shipment(shipment, @invalid_attrs)
      assert shipment == Manifest.get_shipment!(shipment.id)
    end

    test "delete_shipment/1 deletes the shipment" do
      shipment = shipment_fixture()
      assert {:ok, %Shipment{}} = Manifest.delete_shipment(shipment)
      assert_raise Ecto.NoResultsError, fn -> Manifest.get_shipment!(shipment.id) end
    end

    test "change_shipment/1 returns a shipment changeset" do
      shipment = shipment_fixture()
      assert %Ecto.Changeset{} = Manifest.change_shipment(shipment)
    end
  end
end
