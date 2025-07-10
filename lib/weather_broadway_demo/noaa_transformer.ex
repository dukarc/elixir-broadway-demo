defmodule WeatherBroadwayDemo.NoaaTransformer do
  @moduledoc """
  Transforms NOAA Weather.gov API data to our internal weather data format.
  Only includes data that NOAA actually provides.
  """

  def transform_current_conditions(noaa_data) do
    case noaa_data do
      %{"properties" => properties} ->
        %{
          temperature: get_temperature(properties),
          humidity: get_humidity(properties),
          wind_speed: get_wind_speed(properties),
          timestamp: DateTime.utc_now()
        }

      _ ->
        {:error, "Invalid NOAA data format"}
    end
  end

  defp get_temperature(%{"temperature" => %{"value" => temp}}) when is_number(temp) do
    temp
  end

  defp get_temperature(_), do: nil

  defp get_humidity(%{"relativeHumidity" => %{"value" => humidity}}) when is_number(humidity) do
    humidity
  end

  defp get_humidity(_), do: nil

  defp get_wind_speed(%{"windSpeed" => %{"value" => wind_speed}}) when is_number(wind_speed) do
    # Convert from km/h to m/s
    wind_speed / 3.6
  end

  defp get_wind_speed(_), do: nil
end
