# Project Plan: Vanilla Elixir, Phoenix, and Broadway Demo (with PubSub)

## Objective

Demonstrate the capabilities of **Elixir**, **Phoenix**, and **Broadway** using only standard, officially supported libraries and features. The project will highlight real-time data processing and visualization, leveraging **Phoenix.PubSub** for message distribution (no external systems like RabbitMQ).

## Project Scope

- **Elixir**: Showcase concurrency, fault-tolerance, and functional programming.
- **Phoenix**: Provide a real-time web interface for data visualization and management.
- **Broadway**: Build robust, concurrent pipelines using only built-in producers (e.g., GenStage).
- **Phoenix.PubSub**: Use as the message/event distribution mechanism.

## High-Level Architecture

| Component         | Role                                                               |
| ----------------- | ------------------------------------------------------------------ |
| Data Source       | Simulated or real events published via Phoenix.PubSub              |
| Broadway Pipeline | Ingests, transforms, and processes PubSub messages concurrently    |
| Phoenix Web Layer | Displays processed data, pipeline metrics, and status in real time |
| LiveDashboard     | Visualizes Broadway pipeline and system metrics                    |

## Milestones

### 1. Project Setup

- Initialize a new Phoenix project (no umbrella required).
- Add dependencies: `phoenix`, `broadway` (no external Broadway producers).
- Configure **Phoenix.PubSub** as the event source.

### 2. Implement Broadway Pipeline

- Create a Broadway module using a custom GenStage producer that subscribes to Phoenix.PubSub topics.
- Processors handle message transformation and validation.
- Optional batchers for batch processing.
- Integrate Telemetry for metrics and observability.

### 3. Phoenix Integration

- Use Phoenix LiveView for real-time display of processed data and pipeline stats.
- Integrate Phoenix LiveDashboard for monitoring.
- UI: show processed messages, error rates, throughput, etc.

### 4. Demo Scenarios

- Simulate event publishing to PubSub (e.g., via a GenServer or LiveView button).
- Demonstrate fault-tolerance (e.g., processor crash and recovery).
- Show real-time UI updates as data flows through the pipeline.

### 5. Documentation & Testing

- Document architecture, pipeline design, and key decisions in `cursor.md`.
- Add unit/integration tests for Broadway and Phoenix components.
- Provide example usage and instructions for running the demo.

## Deliverables

- **Source code**: Idiomatic, well-structured Elixir and Phoenix codebase.
- **cursor.md**: This project plan, architecture
