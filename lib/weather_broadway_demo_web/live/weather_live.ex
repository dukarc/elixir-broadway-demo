defmodule WeatherBroadwayDemoWeb.WeatherLive do
  use WeatherBroadwayDemoWeb, :live_view
  require Logger

  @topic "weather:updates"

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(WeatherBroadwayDemo.PubSub, @topic)
    end

    stations = WeatherBroadwayDemo.WeatherStations.list_stations()
    default_station = WeatherBroadwayDemo.WeatherStations.get_default_station()

    Logger.info("Mounting LiveView with default station: #{inspect(default_station)}")

    {:ok,
     assign(socket,
       history: [],
       stations: stations,
       selected_station: default_station
     )}
  end

  def handle_info({:weather_update, weather_data}, socket) do
    history =
      [weather_data | socket.assigns.history]
      |> Enum.take(10)

    {:noreply, assign(socket, history: history)}
  end

  def handle_event("select_station", params, socket) do
    Logger.info("select_station event received with params: #{inspect(params)}")

    case params do
      %{"station_id" => station_id} ->
        Logger.info("Looking up station with ID: #{station_id}")
        station = WeatherBroadwayDemo.WeatherStations.get_station_by_id(station_id)
        Logger.info("Found station: #{inspect(station)}")

        # Send station change message via PubSub
        Phoenix.PubSub.broadcast(
          WeatherBroadwayDemo.PubSub,
          "weather_producer:commands",
          {:change_station, station_id}
        )

        # Clear history and update the selected_station assign
        {:noreply,
         assign(socket,
           selected_station: station,
           # Clear the history when switching stations
           history: []
         )}

      _ ->
        Logger.warning("Unexpected params format: #{inspect(params)}")
        {:noreply, socket}
    end
  end
end
