defmodule WeatherBroadwayDemo.WeatherStations do
  @moduledoc """
  Configuration for available weather stations with human-readable names.
  """

  @stations [
    %{
      id: "000PG",
      name: "Southside Road (Salinas, CA)",
      coordinates: [-121.34, 36.79],
      timezone: "America/Los_Angeles"
    },
    %{
      id: "KSFO",
      name: "San Francisco International Airport",
      coordinates: [-122.37, 37.62],
      timezone: "America/Los_Angeles"
    },
    %{
      id: "KJFK",
      name: "John F. Kennedy International Airport (New York)",
      coordinates: [-73.78, 40.64],
      timezone: "America/New_York"
    },
    %{
      id: "KORD",
      name: "O'Hare International Airport (Chicago)",
      coordinates: [-87.90, 41.98],
      timezone: "America/Chicago"
    },
    %{
      id: "KDEN",
      name: "Denver International Airport",
      coordinates: [-104.67, 39.86],
      timezone: "America/Denver"
    }
  ]

  def list_stations do
    @stations
  end

  def get_station_by_id(station_id) do
    Enum.find(@stations, fn station -> station.id == station_id end)
  end

  def get_default_station do
    List.first(@stations)
  end
end
