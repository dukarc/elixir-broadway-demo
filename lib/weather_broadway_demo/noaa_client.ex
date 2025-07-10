defmodule WeatherBroadwayDemo.NoaaClient do
  @moduledoc """
  Client for NOAA Weather.gov API.
  Provides functions to fetch current weather conditions and forecasts.
  """

  @base_url "https://api.weather.gov"
  @user_agent "WeatherBroadwayDemo/1.0 (https://github.com/your-repo)"
  # 30 seconds timeout
  @timeout 30_000

  def test_api do
    # Test with a simple endpoint and longer timeout
    case HTTPoison.get(
           "#{@base_url}/stations",
           [{"User-Agent", @user_agent}],
           timeout: @timeout,
           recv_timeout: @timeout
         ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.puts("Response body (first 200 chars): #{String.slice(body, 0, 200)}")

        case Jason.decode(body) do
          {:ok, data} -> {:ok, data}
          {:error, _} -> {:error, "Received HTML instead of JSON: #{String.slice(body, 0, 100)}"}
        end

      {:ok, %HTTPoison.Response{status_code: status}} ->
        {:error, "API returned status: #{status}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "API request failed: #{reason}"}
    end
  end

  def get_stations do
    case HTTPoison.get(
           "#{@base_url}/stations",
           [{"User-Agent", @user_agent}],
           timeout: @timeout,
           recv_timeout: @timeout
         ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, data} -> {:ok, data}
          {:error, _} -> {:error, "Received HTML instead of JSON"}
        end

      {:ok, %HTTPoison.Response{status_code: status}} ->
        {:error, "Status: #{status}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def get_current_conditions(station_id) do
    case HTTPoison.get(
           "#{@base_url}/stations/#{station_id}/observations/latest",
           [{"User-Agent", @user_agent}],
           timeout: @timeout,
           recv_timeout: @timeout
         ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, data} -> {:ok, data}
          {:error, _} -> {:error, "Received HTML instead of JSON"}
        end

      {:ok, %HTTPoison.Response{status_code: status}} ->
        {:error, "Status: #{status}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def get_forecast(lat, lon) do
    case HTTPoison.get(
           "#{@base_url}/points/#{lat},#{lon}/forecast",
           [{"User-Agent", @user_agent}],
           timeout: @timeout,
           recv_timeout: @timeout
         ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, data} -> {:ok, data}
          {:error, _} -> {:error, "Received HTML instead of JSON"}
        end

      {:ok, %HTTPoison.Response{status_code: status}} ->
        {:error, "Status: #{status}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
