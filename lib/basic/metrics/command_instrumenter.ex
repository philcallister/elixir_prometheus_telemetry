defmodule Basic.Metrics.CommandInstrumenter do
  @moduledoc """
  This is a very simple intrumentation module. It shows the following
  - Setting up a Prometheus counter
  - Attaching the counter event to telemetry (https://github.com/beam-telemetry/telemetry)
  - Handling telemetry events and performing a Prometheus counter increment
  - Executing an event through telemetry
  """

  use Prometheus.Metric

  @doc """
  Initial event instrumentation setup. This setup should happen during the
  initial startup of the application.

  Returns `:ok | {:error, :already_exists}`
  """
  def setup() do
    # Prometheus counter metric
    Counter.declare(
      name: :basic_command_total,
      help: "Command Count",
      labels: [:command]
    )

    # Events to handle
    events = [
      [:basic, :command],
    ]

    # Attach defined events to a telemetry callback
    :telemetry.attach_many("basic-commands", events, &handle_event/4, nil)
  end

  @doc """
  Handle a [:basic, :command] event type. This callback is invoked after a
  call to :telemetry.execute

  This example increments a Prometheus counter with the given command name

  Returns `:ok`

  ## Examples

      iex> :telemetry.execute([:basic, :command], %{}, %{command: "CMD"})
      :ok

  """
  def handle_event([:basic, :command], _count, _metadata = %{command: command}, _config) do
    Counter.inc(name: :basic_command_total, labels: [command])
  end

  @doc """
  Execute a command through telemetry

  Returns `:ok`.

  ## Examples

      iex> Basic.Metrics.CommandInstrumenter.execute("CMD")
      :ok

  """
  def execute(command) do
    :telemetry.execute(
      [:basic, :command],
      %{},
      %{command: command}
    )
  end

end
