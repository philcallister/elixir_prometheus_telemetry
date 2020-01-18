defmodule Basic.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # Setup instrumentation
    Basic.Metrics.Setup.setup()

    children = [
      # Starts a worker by calling: Basic.Worker.start_link(arg)
      # {Basic.Worker, arg}
      Plug.Cowboy.child_spec(scheme: :http, plug: Basic.Web.Router, options: [port: 4000])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Basic.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
