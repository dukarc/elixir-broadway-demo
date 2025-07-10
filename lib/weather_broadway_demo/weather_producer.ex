defmodule WeatherBroadwayDemo.WeatherProducer do
  @moduledoc """
  A custom GenStage producer that fetches real NOAA weather data every 10 seconds.
  Only emits events when real NOAA data is available.
  """

  use GenStage
  require Logger

  # 10 seconds
  @interval 10_000

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    Logger.info("WeatherProducer starting with station: 000PG")

    # Subscribe to PubSub for station change commands
    Phoenix.PubSub.subscribe(WeatherBroadwayDemo.PubSub, "weather_producer:commands")

    schedule_tick()
    {:producer, %{demand: 0, buffer: [], station_id: "000PG"}}
  end

  @impl true
  def handle_demand(incoming_demand, state) when incoming_demand > 0 do
    Logger.info(
      "WeatherProducer received demand: #{incoming_demand}, current demand: #{state.demand}"
    )

    state = %{state | demand: state.demand + incoming_demand}
    dispatch_events(state)
  end

  @impl true
  def handle_info(:tick, state) do
    Logger.info("WeatherProducer tick - fetching data for station: #{state.station_id}")

    case fetch_weather_event(state.station_id) do
      {:ok, event} ->
        Logger.info("WeatherProducer successfully fetched data, adding to buffer")
        state = %{state | buffer: state.buffer ++ [event]}
        schedule_tick()
        dispatch_events(state)

      {:error, reason} ->
        Logger.warning(
          "WeatherProducer failed to fetch NOAA weather data for station #{state.station_id}: #{reason}"
        )

        schedule_tick()
        dispatch_events(state)
    end
  end

  # Handle station change requests via PubSub
  def handle_info({:change_station, station_id}, state) do
    Logger.info("WeatherProducer received PubSub message to change station to: #{station_id}")
    schedule_tick()
    {:noreply, [], %{state | station_id: station_id}}
  end

  defp dispatch_events(%{demand: demand, buffer: buffer} = state)
       when demand > 0 and buffer != [] do
    Logger.info("WeatherProducer dispatching #{length(buffer)} events, demand: #{demand}")
    {to_send, remaining} = Enum.split(buffer, demand)
    {:noreply, to_send, %{state | demand: state.demand - length(to_send), buffer: remaining}}
  end

  defp dispatch_events(state) do
    Logger.info(
      "WeatherProducer no events to dispatch, demand: #{state.demand}, buffer size: #{length(state.buffer)}"
    )

    {:noreply, [], state}
  end

  defp schedule_tick do
    Logger.info("WeatherProducer scheduling next tick in #{@interval}ms")
    Process.send_after(self(), :tick, @interval)
  end

  defp fetch_weather_event(station_id) do
    Logger.info("WeatherProducer fetching weather for station: #{station_id}")

    case WeatherBroadwayDemo.NoaaClient.get_current_conditions(station_id) do
      {:ok, noaa_data} ->
        Logger.info("WeatherProducer received NOAA data, transforming...")

        case WeatherBroadwayDemo.NoaaTransformer.transform_current_conditions(noaa_data) do
          weather_data when is_map(weather_data) ->
            Logger.info("WeatherProducer successfully transformed data: #{inspect(weather_data)}")

            {:ok,
             %Broadway.Message{
               data: weather_data,
               acknowledger: Broadway.NoopAcknowledger.init()
             }}

          {:error, reason} ->
            Logger.error("WeatherProducer failed to transform NOAA data: #{reason}")
            {:error, "Failed to transform NOAA data: #{reason}"}
        end

      {:error, reason} ->
        Logger.error("WeatherProducer failed to fetch NOAA data: #{reason}")
        {:error, "Failed to fetch NOAA data: #{reason}"}
    end
  end

  # Public function to change station - use PubSub
  def change_station(station_id) do
    Logger.info("WeatherProducer.change_station called with: #{station_id}")

    Phoenix.PubSub.broadcast(
      WeatherBroadwayDemo.PubSub,
      "weather_producer:commands",
      {:change_station, station_id}
    )
  end
end
