# WeatherBroadwayDemo

A real-time weather data processing demo built with **Elixir**, **Phoenix**, and **Broadway**. This project demonstrates:

- **Real-time data processing** with Broadway pipelines
- **Live weather data** from NOAA Weather.gov API
- **Interactive station selection** with multiple weather stations
- **Real-time UI updates** using Phoenix LiveView
- **Broadway dashboard** for pipeline monitoring



https://github.com/user-attachments/assets/7322031f-28a0-42e3-9d05-9f431b83b22f



## Quick Start

### 1. Install asdf (if not already installed)

```bash
# macOS
brew install asdf

# Linux
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
echo '. "$HOME/.asdf/asdf.sh"' >> ~/.bashrc
source ~/.bashrc
```

### 2. Install Elixir/Erlang versions from .tool-versions

```bash
asdf install
```

### 3. Start the Phoenix server

```bash
mix phx.server
```

### 4. View the demo

- **Weather Dashboard**: http://localhost:4000/weather
- **Broadway Dashboard**: http://localhost:4000/dashboard

## What You'll See

- **Real-time weather data** from NOAA Weather.gov API
- **Station selection dropdown** with 5 major weather stations
- **Live updates** every 10 seconds
- **Broadway pipeline visualization** showing data flow
- **Phoenix LiveView** real-time UI updates

## Architecture

- **WeatherProducer**: Custom GenStage producer fetching NOAA data
- **WeatherBroadway**: Broadway pipeline processing weather events
- **Phoenix LiveView**: Real-time UI with station selection
- **Phoenix.PubSub**: Message distribution between components
