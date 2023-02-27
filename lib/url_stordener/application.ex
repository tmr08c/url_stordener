defmodule UrlStordener.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      UrlStordenerWeb.Telemetry,
      # Start the Ecto repository
      UrlStordener.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: UrlStordener.PubSub},
      # Start Finch
      {Finch, name: UrlStordener.Finch},
      # Start the Endpoint (http/https)
      UrlStordenerWeb.Endpoint,
      # Start a worker by calling: UrlStordener.Worker.start_link(arg)
      # {UrlStordener.Worker, arg}
      {Task.Supervisor, name: UrlStordener.TaskSupervisor}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UrlStordener.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UrlStordenerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
