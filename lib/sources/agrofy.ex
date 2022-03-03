defmodule Dolarblue.Sources.Agrofy do
  @link "https://api-cotizaciones.agrofy.com/api/EconomicIndic/GetEconomicIndicators"

  def get_source do
    {"agrofy", &fetch_values/0}
  end

  def fetch_values() do
    HTTPoison.get!(@link)
    |> (fn response -> Poison.decode!(response.body) end).()
    |> Enum.filter(fn element -> Map.get(element, "name") == "Monedas" end)
    |> (fn [monedas] -> Map.get(monedas, "items") end).()
    |> Enum.filter(fn moneda -> Map.get(moneda, "name") == "U$ Blue" end)
    |> (fn [blue] -> {Map.get(blue, "buy"), Map.get(blue, "sell")} end).()
    |> Tools.FloatUtils.parse_string_tuple()
    |> Structures.DolarblueData.build_dolarblue()
  end
end
