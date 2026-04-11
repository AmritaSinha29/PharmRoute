defmodule PharmRoute.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PharmRouteWeb.Telemetry,
      PharmRoute.Repo,
      {DNSCluster, query: Application.get_env(:pharm_route, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PharmRoute.PubSub},
      # Start a worker by calling: PharmRoute.Worker.start_link(arg)
      # {PharmRoute.Worker, arg},
      # Start to serve requests, typically the last entry
      PharmRouteWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PharmRoute.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PharmRouteWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
