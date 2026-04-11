defmodule PharmRoute.Manifest do
  @moduledoc """
  The Manifest context.
  """

  import Ecto.Query, warn: false
  alias PharmRoute.Repo

  alias PharmRoute.Manifest.Substance

  @doc """
  Returns the list of substances.

  ## Examples

      iex> list_substances()
      [%Substance{}, ...]

  """
  def list_substances do
    Repo.all(Substance)
  end

  @doc """
  Gets a single substance.

  Raises `Ecto.NoResultsError` if the Substance does not exist.

  ## Examples

      iex> get_substance!(123)
      %Substance{}

      iex> get_substance!(456)
      ** (Ecto.NoResultsError)

  """
  def get_substance!(id), do: Repo.get!(Substance, id)

  @doc """
  Creates a substance.

  ## Examples

      iex> create_substance(%{field: value})
      {:ok, %Substance{}}

      iex> create_substance(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_substance(attrs \\ %{}) do
    %Substance{}
    |> Substance.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a substance.

  ## Examples

      iex> update_substance(substance, %{field: new_value})
      {:ok, %Substance{}}

      iex> update_substance(substance, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_substance(%Substance{} = substance, attrs) do
    substance
    |> Substance.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a substance.

  ## Examples

      iex> delete_substance(substance)
      {:ok, %Substance{}}

      iex> delete_substance(substance)
      {:error, %Ecto.Changeset{}}

  """
  def delete_substance(%Substance{} = substance) do
    Repo.delete(substance)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking substance changes.

  ## Examples

      iex> change_substance(substance)
      %Ecto.Changeset{data: %Substance{}}

  """
  def change_substance(%Substance{} = substance, attrs \\ %{}) do
    Substance.changeset(substance, attrs)
  end

  alias PharmRoute.Manifest.Shipment

  @doc """
  Returns the list of shipments.

  ## Examples

      iex> list_shipments()
      [%Shipment{}, ...]

  """
  def list_shipments do
    Repo.all(Shipment)
  end

  @doc """
  Gets a single shipment.

  Raises `Ecto.NoResultsError` if the Shipment does not exist.

  ## Examples

      iex> get_shipment!(123)
      %Shipment{}

      iex> get_shipment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_shipment!(id), do: Repo.get!(Shipment, id)

  @doc """
  Creates a shipment.

  ## Examples

      iex> create_shipment(%{field: value})
      {:ok, %Shipment{}}

      iex> create_shipment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_shipment(attrs \\ %{}) do
    %Shipment{}
    |> Shipment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a shipment.

  ## Examples

      iex> update_shipment(shipment, %{field: new_value})
      {:ok, %Shipment{}}

      iex> update_shipment(shipment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_shipment(%Shipment{} = shipment, attrs) do
    shipment
    |> Shipment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a shipment.

  ## Examples

      iex> delete_shipment(shipment)
      {:ok, %Shipment{}}

      iex> delete_shipment(shipment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_shipment(%Shipment{} = shipment) do
    Repo.delete(shipment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking shipment changes.

  ## Examples

      iex> change_shipment(shipment)
      %Ecto.Changeset{data: %Shipment{}}

  """
  def change_shipment(%Shipment{} = shipment, attrs \\ %{}) do
    Shipment.changeset(shipment, attrs)
  end
end
