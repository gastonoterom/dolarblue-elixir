defmodule Dolarblue.AverageStore do
  use Agent

  @name __MODULE__

  #####
  # API

  def start_link(_) do
    init_value = %{
      sell_average: nil,
      buy_average: nil,
      timestamp: DateTime.utc_now()
    }

    Agent.start_link(fn -> init_value end, name: @name)
  end

  def save_average(dolarblue_list) do
    {buy_average, sell_average} =
      dolarblue_list
      |> Tools.DolarblueUtils.filter_by_age(DateTime.utc_now(), 7200)
      |> Tools.DolarblueUtils.calculate_average()

    Agent.update(@name, fn _ ->
      %{buy_average: buy_average, sell_average: sell_average, timestamp: DateTime.utc_now()}
    end)
  end

  def get_average() do
    Agent.get(@name, fn state -> state end)
  end
end
