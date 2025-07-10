defmodule WeatherBroadwayDemo.WeatherProducer do
  @moduledoc """
  A custom GenStage producer that emits random weather data every 10 seconds.
  This is used as a stand-in for real weather API data during development.
  """

  use GenStage

  @interval 10_000

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    schedule_tick()
    {:producer, %{demand: 0, buffer: []}}
  end

  @impl true
  def handle_demand(incoming_demand, state) when incoming_demand > 0 do
    state = %{state | demand: state.demand + incoming_demand}
    dispatch_events(state)
  end

  @impl true
  def handle_info(:tick, state) do
    event = generate_weather_event()
    state = %{state | buffer: state.buffer ++ [event]}
    schedule_tick()
    dispatch_events(state)
  end

  defp dispatch_events(%{demand: demand, buffer: buffer} = state)
       when demand > 0 and buffer != [] do
    {to_send, remaining} = Enum.split(buffer, demand)
    {:noreply, to_send, %{state | demand: state.demand - length(to_send), buffer: remaining}}
  end

  defp dispatch_events(state), do: {:noreply, [], state}

  defp schedule_tick do
    Process.send_after(self(), :tick, @interval)
  end

  defp generate_weather_event do
    %Broadway.Message{
      data: %{
        temperature: :rand.uniform(40) - 10,
        humidity: :rand.uniform(100),
        pressure: 950 + :rand.uniform(100),
        wind_speed: Float.round(:rand.uniform() * 15, 1),
        condition: Enum.random(["sunny", "cloudy", "rain", "storm", "snow"]),
        timestamp: DateTime.utc_now()
      },
      acknowledger: Broadway.NoopAcknowledger.init()
    }
  end
end
