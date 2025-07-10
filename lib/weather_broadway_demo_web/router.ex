defmodule WeatherBroadwayDemoWeb.Router do
  use WeatherBroadwayDemoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {WeatherBroadwayDemoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WeatherBroadwayDemoWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/weather", WeatherLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", WeatherBroadwayDemoWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:weather_broadway_demo, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    if Mix.env() in [:dev, :test] do
      scope "/" do
        pipe_through :browser

        live_dashboard "/dashboard",
          metrics: WeatherBroadwayDemoWeb.Telemetry,
          additional_pages: [
            broadway: {BroadwayDashboard, pipelines: [WeatherBroadwayDemo.WeatherBroadway]}
          ]
      end
    end
  end
end
