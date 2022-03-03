defmodule Tools.DolarblueUtils do
  def filter_by_age(dolarblue_list, now, max_age) do
    dolarblue_list
    |> Enum.filter(fn {_source, data} -> DateTime.diff(now, data.datetime) <= max_age end)
  end

  def calculate_average(dolarblue_list) do
    dolarblue_list
    |> Enum.map(fn {_source, dolarblue} ->
      {Map.get(dolarblue, :buy_price), Map.get(dolarblue, :sell_price)}
    end)
    |> Enum.reduce({0, 0, 0}, fn {buy_price, sell_price}, {buy_sum, sell_sum, i} ->
      {buy_sum + buy_price, sell_sum + sell_price, i + 1}
    end)
    |> (fn {buy_sum, sell_sum, i} ->
          {buy_sum / i, sell_sum / i}
        end).()
  end
end
