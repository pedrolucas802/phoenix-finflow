defmodule PhoenixFinflow.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PhoenixFinflowWeb.Telemetry,
      PhoenixFinflow.Repo,
      {DNSCluster, query: Application.get_env(:phoenix_finflow, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PhoenixFinflow.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PhoenixFinflow.Finch},
      # Start a worker by calling: PhoenixFinflow.Worker.start_link(arg)
      # {PhoenixFinflow.Worker, arg},
      # Start to serve requests, typically the last entry
      PhoenixFinflowWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixFinflow.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhoenixFinflowWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
