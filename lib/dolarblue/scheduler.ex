defmodule Dolarblue.Scheduler do
  use GenServer

  require Logger

  @me Scheduler

  ####
  # Api
  def start_link(timeout) do
    GenServer.start_link(__MODULE__, timeout, name: @me)
  end

  ####
  # Internal implementation

  # Init
  def init(timeout) do
    Process.send_after(self(), :schedule, 0)
    {:ok, timeout}
  end

  def handle_info(:schedule, timeout) do
    Dolarblue.Fetcher.fetch()
    Process.send_after(self(), :schedule, timeout)
    {:noreply, timeout}
  end
end
