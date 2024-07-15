defmodule FgAuth.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FgAuthWeb.Telemetry,
      FgAuth.Repo,
      {DNSCluster, query: Application.get_env(:fg_auth, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FgAuth.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: FgAuth.Finch},
      # Start a worker by calling: FgAuth.Worker.start_link(arg)
      # {FgAuth.Worker, arg},
      # Start to serve requests, typically the last entry
      FgAuthWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FgAuth.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FgAuthWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
