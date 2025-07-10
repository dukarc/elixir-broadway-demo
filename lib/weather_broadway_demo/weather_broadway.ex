defmodule WeatherBroadwayDemo.WeatherBroadway do
  @moduledoc """
  Broadway pipeline for processing weather data from WeatherProducer.
  For now, it simply logs each weather event.
  """

  use Broadway
  require Logger

  alias WeatherBroadwayDemo.WeatherProducer

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [module: {WeatherProducer, []}],
      processors: [default: [concurrency: 2]]
    )
  end

  @impl true
  def handle_message(_processor, %Broadway.Message{data: weather_data} = msg, _context) do
    Logger.info("Weather event: #{inspect(weather_data)}")

    Phoenix.PubSub.broadcast(
      WeatherBroadwayDemo.PubSub,
      "weather:updates",
      {:weather_update, weather_data}
    )

    msg
  end
end
