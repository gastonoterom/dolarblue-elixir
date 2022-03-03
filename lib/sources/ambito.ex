defmodule Dolarblue.Sources.Ambito do
  @link "https://mercados.ambito.com//dolar/informal/variacion"

  def get_source do
    {"ambito", &fetch_values/0}
  end

  def fetch_values() do
    HTTPoison.get!(@link)
    |> (fn response -> Poison.decode!(response.body) end).()
    |> (fn blue -> {Map.get(blue, "compra"), Map.get(blue, "venta")} end).()
    |> Tools.FloatUtils.parse_string_tuple()
    |> Structures.DolarblueData.build_dolarblue()
  end
end
