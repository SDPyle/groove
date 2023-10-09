defmodule Groove.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies)

    children = [
      {Cluster.Supervisor, [topologies, [name: Groove.ClusterSupervisor]]},
      # Start the Telemetry supervisor
      GrooveWeb.Telemetry,
      # Start the Ecto repository
      Groove.Repo,
      # Start the authentication supervisor
      {AshAuthentication.Supervisor, otp_app: :groove},
      # Start the PubSub system
      {Phoenix.PubSub, name: Groove.PubSub},
      # Start Finch
      {Finch, name: Groove.Finch},
      # Start the Endpoint (http/https)
      GrooveWeb.Endpoint
      # Start a worker by calling: Groove.Worker.start_link(arg)
      # {Groove.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Groove.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GrooveWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
