defmodule PharmRoute.AI.Gemini do
  @moduledoc """
  Client for interacting with Google's Gemini 1.5 Pro REST API for BMR extraction.
  """
  
  @model_url "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent"

  @prompt """
  Extract the following manifest intelligence data from this document.
  Respond STRICTLY with JSON following this schema, with no markdown code blocks or extra text:
  {
    "product_name": "string",
    "dosage": "string",
    "batch_date": "YYYY-MM-DD",
    "ingredients": [
      {
        "name": "string",
        "cas_number": "string",
        "role": "string",
        "confidence": 0.0
      }
    ]
  }
  """

  def extract_bmr(base64_pdf) do
    api_key = System.get_env("GEMINI_API_KEY") || raise "GEMINI_API_KEY not set"
    
    payload = %{
      "contents" => [
        %{
          "parts" => [
            %{"text" => @prompt},
            %{
              "inline_data" => %{
                "mime_type" => "application/pdf",
                "data" => base64_pdf
              }
            }
          ]
        }
      ],
      "generationConfig" => %{
        "response_mime_type" => "application/json"
      }
    }

    url = "#{@model_url}?key=#{api_key}"
    
    case Req.post(url, json: payload, receive_timeout: 30_000) do
      {:ok, %{status: 200, body: %{"candidates" => [%{"content" => %{"parts" => [%{"text" => json_text}]}} | _]}}} ->
        case Jason.decode(json_text) do
          {:ok, map} -> {:ok, map}
          {:error, _} -> {:error, "Failed to parse Gemini JSON output"}
        end
        
      {:ok, %{status: status, body: body}} ->
        {:error, "API returned status #{status}: #{inspect(body)}"}
        
      {:error, exception} ->
        {:error, inspect(exception)}
    end
  end

  @doc """
  Generate human-readable remediation advice for a failed compliance check.
  Uses Gemini to produce contextual, actionable guidance based on the rule
  and shipment context. Falls back to the rule's static template if the API
  is unavailable.
  """
  def generate_remediation(rule, shipment_data) do
    api_key = System.get_env("GEMINI_API_KEY")

    if is_nil(api_key) do
      {:ok, rule.remediation_template || "No remediation guidance available."}
    else
      prompt = """
      You are a pharmaceutical regulatory compliance expert.
      A shipment has FAILED the following compliance check:

      Rule: #{rule.rule_name}
      Description: #{rule.description}
      Severity: #{rule.severity}
      Country: #{rule.country_code}

      Shipment context:
      #{inspect(shipment_data)}

      Based on the rule template below, generate a clear, actionable remediation plan
      with specific steps, estimated timelines, and relevant regulatory references.
      Keep it concise (max 200 words).

      Template: #{rule.remediation_template}
      """

      payload = %{
        "contents" => [%{"parts" => [%{"text" => prompt}]}],
        "generationConfig" => %{"maxOutputTokens" => 300}
      }

      url = "#{@model_url}?key=#{api_key}"

      case Req.post(url, json: payload, receive_timeout: 15_000) do
        {:ok, %{status: 200, body: %{"candidates" => [%{"content" => %{"parts" => [%{"text" => text}]}} | _]}}} ->
          {:ok, text}

        _ ->
          # Graceful fallback to static template
          {:ok, rule.remediation_template || "No remediation guidance available."}
      end
    end
  end
end

