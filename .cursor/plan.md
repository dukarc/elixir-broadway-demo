# Project Plan: Elixir, Phoenix, and Broadway Demo with Real Weather Data

## Objective

Demonstrate the capabilities of **Elixir**, **Phoenix**, and **Broadway** using real weather data. The project will highlight real-time data processing and visualization, leveraging **Phoenix.PubSub** for message distribution and a **custom GenStage Producer** for robust weather data ingestion.

## Project Scope

- **Elixir**: Showcase concurrency, fault-tolerance, and functional programming.
- **Phoenix**: Provide a real-time web interface for weather data visualization and management.
- **Broadway**: Build robust, concurrent pipelines using a custom GenStage producer for weather data ingestion.
- **Phoenix.PubSub**: Use as the message/event distribution mechanism.
- **Weather Data**: Integrate real weather API with ~10-second update intervals.
- **Demo Frontend**: Real-time HTML interface showing live weather data updates.

## High-Level Architecture

| Component                | Role                                                               |
| ------------------------ | ------------------------------------------------------------------ |
| Weather API              | External weather service providing real-time weather data          |
| Custom GenStage Producer | Fetches weather data every ~10 seconds and emits to Broadway       |
| Broadway Pipeline        | Ingests weather data via custom producer, transforms and processes |
| Phoenix LiveView         | Real-time HTML interface displaying live weather data updates      |
| LiveDashboard            | Visualizes Broadway pipeline and system metrics                    |

## Demo Frontend Requirements

### Real-Time Weather Display

- **Live Updates**: Weather data updates automatically every time new data arrives (~10 seconds)
- **Current Weather**: Display temperature, humidity, pressure, wind speed, conditions
- **Visual Indicators**: Icons, color coding, and animations for weather changes
- **Historical Data**: Show recent weather history (last 10-20 updates)
- **Pipeline Status**: Real-time indicators showing Broadway pipeline health

### Frontend Features

- **Auto-refresh**: No manual refresh needed - LiveView handles real-time updates
- **Responsive Design**: Works on desktop and mobile devices
- **Error Handling**: Graceful display of API failures or pipeline issues
- **Loading States**: Smooth transitions between data updates
- **Weather Icons**: Visual representation of weather conditions

## Custom GenStage Producer Design

### WeatherProducer

- **Role**: Custom GenStage producer that fetches weather data
- **Behavior**:
  - Fetches weather data every ~10 seconds via HTTP
  - Handles API rate limits and failures gracefully
  - Emits weather data events to Broadway pipeline
  - Implements backpressure handling
- **Features**:
  - Fault-tolerant with automatic retry logic
  - Configurable polling intervals
  - Error handling and logging
  - Telemetry integration for monitoring

## Weather Data Integration Options

### Option 1: OpenWeatherMap API

- **Pros**: Free tier available, comprehensive data, reliable
- **Cons**: Rate limits on free tier
- **Update Frequency**: Can be configured for ~10-second intervals

### Option 2: WeatherAPI.com

- **Pros**: Good free tier, detailed weather data
- **Cons**: Rate limits
- **Update Frequency**: Configurable intervals

### Option 3: Simulated Weather Data (Fallback)

- **Pros**: No rate limits, predictable data
- **Cons**: Not real data
- **Update Frequency**: Exactly 10 seconds

## Milestones

### 1. Project Setup - COMPLETED

- Initialize a new Phoenix project (no umbrella required).
- Add dependencies: `phoenix`, `broadway`, `httpoison` (for weather API calls).
- Configure **Phoenix.PubSub** as the event distribution mechanism.
- Choose and configure weather data source.

### 2. Implement Custom GenStage Producer

- Create `WeatherProducer` module implementing GenStage behavior.
- Implement weather data fetching logic with HTTP client.
- Add error handling, retry logic, and backpressure management.
- Configure producer to emit events every ~10 seconds.
- Integrate Telemetry for producer metrics.

### 3. Implement Broadway Pipeline

- Create Broadway module using the custom `WeatherProducer`.
- Processors handle weather data transformation and validation.
- Optional batchers for batch processing of weather updates.
- Integrate Telemetry for metrics and observability.

### 4. Phoenix LiveView Frontend

- Create real-time HTML interface using Phoenix LiveView.
- Display live weather data that updates automatically with each new data point.
- Implement responsive design with weather icons and visual indicators.
- Show pipeline status and error states in real-time.
- Add historical weather data display (last 10-20 updates).

### 5. Demo Scenarios

- Real-time weather data ingestion every ~10 seconds via custom producer.
- Live HTML frontend updates automatically showing new weather data.
- Demonstrate fault-tolerance (e.g., API failure and producer recovery).
- Show real-time UI updates as weather data flows through the pipeline.
- Weather data visualization with smooth transitions and loading states.

### 6. Documentation & Testing

- Document architecture, pipeline design, and key decisions in `cursor.md`.
- Add unit/integration tests for Broadway and Phoenix components.
- Provide example usage and instructions for running the demo.

## Deliverables

- **Source code**: Idiomatic, well-structured Elixir and Phoenix codebase.
- **Custom GenStage Producer**: Robust weather data ingestion component.
- **Real-time HTML Frontend**: Live weather data display with automatic updates.
- **cursor.md**: This project plan, architecture documentation.
