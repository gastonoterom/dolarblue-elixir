defmodule Dolarblue.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Dolarblue.DataStore,
      Dolarblue.AverageStore,
      Dolarblue.ReportStore,
      {Dolarblue.Fetcher, [Storer]},
      Dolarblue.Fetcher.Worker,
      Dolarblue.Storer,
      {Dolarblue.Scheduler, 1_800_000},
      Plug.Adapters.Cowboy.child_spec(
        scheme: :http,
        plug: HttpServer.Router,
        options: [port: 8085]
      )
    ]

    opts = [strategy: :one_for_all, name: Dolarblue.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
