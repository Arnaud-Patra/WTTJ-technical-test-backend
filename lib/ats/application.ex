defmodule Ats.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      AtsWeb.Telemetry,
      # Start the Ecto repository
      Ats.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Ats.PubSub},
      # Start Finch
      {Finch, name: Ats.Finch},
      # Start the Endpoint (http/https)
      AtsWeb.Endpoint
      # Start a worker by calling: Ats.Worker.start_link(arg)
      # {Ats.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ats.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AtsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
