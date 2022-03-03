defmodule Dolarblue.Storer do
  use GenServer

  @me Storer

  ####
  # Api
  def start_link(_) do
    GenServer.start_link(__MODULE__, {}, name: @me)
  end

  ####
  # Internal implementation

  # Init
  def init(state) do
    {:ok, state}
  end

  # Fetch
  def handle_cast({:result, results}, _) do
    Dolarblue.DataStore.save_data(results)
    Dolarblue.ReportStore.save_report(results)
    Dolarblue.AverageStore.save_average(results)

    {:noreply, {}}
  end
end
