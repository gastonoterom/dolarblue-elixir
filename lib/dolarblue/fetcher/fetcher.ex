defmodule Dolarblue.Fetcher do
  use GenServer

  @me Fetcher

  ######
  ## API

  def start_link() do
    start_link([])
  end

  def start_link(subscribers) do
    GenServer.start_link(__MODULE__, {subscribers}, name: @me)
  end

  def subscribe(pid) do
    GenServer.call(@me, {:subscribe, pid})
  end

  def unsubscribe(pid) do
    GenServer.call(@me, {:unsubscribe, pid})
  end

  def fetch() do
    GenServer.cast(@me, :fetch)
  end

  ######
  ## Server

  # Init
  def init(state) do
    {:ok, state}
  end

  # Subscribe
  def handle_call({:subscribe, pid}, _from, {subscribers}) do
    {:reply,
     {
       :subscribe_success,
       [pid | subscribers]
     }, {[pid | subscribers]}}
  end

  # Unsubscribe
  def handle_call({:unsubscribe, pid}, _from, {subscribers}) do
    unsubscribed_list = Enum.filter(subscribers, fn subscriber -> subscriber != pid end)

    {:reply,
     {
       :unsubscribe_success,
       unsubscribed_list
     }, {unsubscribed_list}}
  end

  # Fetch
  def handle_cast(:fetch, {subscribers}) do
    Dolarblue.Fetcher.Worker.fetch_values(@me)

    {:noreply, {subscribers}}
  end

  def handle_cast({:result, results}, {subscribers}) do
    subscribers
    |> Enum.each(fn subscriber -> GenServer.cast(subscriber, {:result, results}) end)

    {:noreply, {subscribers}}
  end
end
