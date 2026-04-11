defmodule PharmRoute.Compliance do
  @moduledoc """
  Deterministic compliance evaluation engine.

  Evaluates shipment data against configurable rules stored in PostgreSQL.
  The LLM (Gemini) is NEVER used for pass/fail decisions — only for generating
  human-readable remediation advice when a check fails.
  """
  import Ecto.Query
  alias PharmRoute.Repo
  alias PharmRoute.Compliance.Rule

  @doc """
  Evaluates a shipment against all active compliance rules for the given destination.

  ## Parameters
    - `shipment_data` — A map containing extracted shipment fields. Keys should be
      strings matching rule `condition_field` values (e.g., "is_controlled", "dea_schedule").
    - `destination_country` — ISO 3-letter country code (e.g., "NLD", "USA", "IND").

  ## Returns
    A map with:
    - `:overall_status` — `:green`, `:amber`, or `:red`
    - `:checks` — List of individual check result maps
    - `:summary` — Human-readable summary string
  """
  def evaluate_shipment(shipment_data, destination_country) do
    rules = fetch_active_rules(destination_country)

    checks =
      rules
      |> Enum.map(fn rule -> evaluate_rule(rule, shipment_data) end)

    overall_status = determine_overall_status(checks)

    critical_fails = Enum.count(checks, &(&1.status == :fail && &1.severity == "critical"))
    warning_fails = Enum.count(checks, &(&1.status == :fail && &1.severity == "warning"))
    passes = Enum.count(checks, &(&1.status == :pass))

    summary =
      "#{length(checks)} checks evaluated: #{passes} passed, " <>
        "#{critical_fails} critical failures, #{warning_fails} warnings."

    %{
      overall_status: overall_status,
      checks: checks,
      summary: summary,
      destination: destination_country,
      total_checks: length(checks),
      critical_failures: critical_fails,
      warnings: warning_fails
    }
  end

  @doc """
  Fetches all active compliance rules for a given country code.
  """
  def fetch_active_rules(country_code) do
    Rule
    |> where([r], r.country_code == ^country_code and r.is_active == true)
    |> order_by([r], asc: r.severity, asc: r.rule_name)
    |> Repo.all()
  end

  @doc """
  Lists all distinct country codes that have active rules.
  """
  def list_supported_countries do
    Rule
    |> where([r], r.is_active == true)
    |> select([r], r.country_code)
    |> distinct(true)
    |> Repo.all()
  end

  # ── Private: Deterministic Rule Evaluation ──

  defp evaluate_rule(rule, shipment_data) do
    field_value = Map.get(shipment_data, rule.condition_field)
    passed = evaluate_condition(rule.condition_operator, field_value, rule.condition_value)

    remediation =
      if passed do
        nil
      else
        interpolate_remediation(rule.remediation_template, shipment_data)
      end

    %{
      rule_id: rule.id,
      rule_name: rule.rule_name,
      check_type: rule.check_type,
      severity: rule.severity,
      description: rule.description,
      status: if(passed, do: :pass, else: :fail),
      remediation: remediation
    }
  end

  defp evaluate_condition("equals", field_value, condition_value) do
    to_string(field_value) == condition_value
  end

  defp evaluate_condition("not_equals", field_value, condition_value) do
    to_string(field_value) != condition_value
  end

  defp evaluate_condition("contains", field_value, condition_value) when is_binary(field_value) do
    String.contains?(field_value, condition_value)
  end

  defp evaluate_condition("not_contains", field_value, condition_value) when is_binary(field_value) do
    not String.contains?(field_value, condition_value)
  end

  defp evaluate_condition("is_true", field_value, _condition_value) do
    field_value == true || field_value == "true"
  end

  defp evaluate_condition("is_false", field_value, _condition_value) do
    field_value == false || field_value == "false" || is_nil(field_value)
  end

  defp evaluate_condition("exists", field_value, _condition_value) do
    not is_nil(field_value) and field_value != "" and field_value != false
  end

  defp evaluate_condition("not_exists", field_value, _condition_value) do
    is_nil(field_value) or field_value == "" or field_value == false
  end

  defp evaluate_condition("greater_than", field_value, condition_value) do
    case {Float.parse(to_string(field_value)), Float.parse(condition_value)} do
      {{fv, _}, {cv, _}} -> fv > cv
      _ -> false
    end
  end

  defp evaluate_condition("less_than", field_value, condition_value) do
    case {Float.parse(to_string(field_value)), Float.parse(condition_value)} do
      {{fv, _}, {cv, _}} -> fv < cv
      _ -> false
    end
  end

  defp evaluate_condition("in_list", field_value, condition_value) do
    list = String.split(condition_value, ",") |> Enum.map(&String.trim/1)
    to_string(field_value) in list
  end

  defp evaluate_condition("not_in_list", field_value, condition_value) do
    list = String.split(condition_value, ",") |> Enum.map(&String.trim/1)
    to_string(field_value) not in list
  end

  defp evaluate_condition(_operator, _field_value, _condition_value), do: false

  # ── Private Helpers ──

  defp determine_overall_status(checks) do
    has_critical_fail = Enum.any?(checks, &(&1.status == :fail && &1.severity == "critical"))
    has_warning_fail = Enum.any?(checks, &(&1.status == :fail && &1.severity == "warning"))

    cond do
      has_critical_fail -> :red
      has_warning_fail -> :amber
      true -> :green
    end
  end

  defp interpolate_remediation(nil, _data), do: nil

  defp interpolate_remediation(template, data) do
    Regex.replace(~r/\{(\w+)\}/, template, fn _full, key ->
      case Map.get(data, key) do
        nil -> "{#{key}}"
        value -> to_string(value)
      end
    end)
  end
end
