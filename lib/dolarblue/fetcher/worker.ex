defmodule Dolarblue.Fetcher.Worker do
  use GenServer

  @me Fetcher.Worker

  ####
  # API
  def start_link(_) do
    GenServer.start_link(__MODULE__, {}, name: @me)
  end

  def fetch_values(pid) do
    GenServer.cast(@me, {:work, pid})
  end

  ####
  # Server implementation

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:work, pid}, _) do
    GenServer.cast(pid, {:result, fetch_all_values()})

    {:noreply, {}}
  end

  ####
  # Private functions
  defp timeout_fetch(source, fetching_fun, timeout) do
    me = self()

    Task.start(fn ->
      try do
        send(me, {:ok, fetching_fun.()})
      rescue
        _ -> send(me, {:error})
      end
    end)

    receive do
      {:ok, val} -> {source, val}
      {:error} -> {source, nil}
    after
      timeout -> {source, nil}
    end
  end

  defp fetch_all_values do
    Dolarblue.Sources.Provider.get_all()
    |> Enum.map(fn {source, fetch_values} ->
      Task.async(fn -> timeout_fetch(source, fetch_values, 30_000) end)
    end)
    |> Task.await_many(120_000)
  end
end
