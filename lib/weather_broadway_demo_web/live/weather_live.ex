defmodule WeatherBroadwayDemoWeb.WeatherLive do
  use WeatherBroadwayDemoWeb, :live_view

  @topic "weather:updates"

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(WeatherBroadwayDemo.PubSub, @topic)
    end

    {:ok, assign(socket, history: [])}
  end

  def handle_info({:weather_update, weather_data}, socket) do
    history =
      [weather_data | socket.assigns.history]
      |> Enum.take(10)

    {:noreply, assign(socket, history: history)}
  end
end
