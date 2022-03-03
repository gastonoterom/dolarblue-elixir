defmodule Dolarblue.Sources.LaNacion do
  @link "https://www.lanacion.com.ar/dolar-hoy/"

  def get_source do
    {"la_nacion", &fetch_values/0}
  end

  def fetch_values() do
    HTTPoison.get!(@link)
    |> (fn response -> Floki.parse_document(response.body) end).()
    |> (fn {_, document} -> get_dolar_values(document) end).()
    |> Structures.DolarblueData.build_dolarblue()
  end

  defp get_dolar_values(document) do
    document
    |> Floki.find(".currency-data")
    |> Enum.map(fn div ->
      {
        Floki.find(div, ".dolar-title, .--font-bold, .--twoxs") |> Floki.text(),
        Floki.find(div, "strong")
        |> Floki.text()
        |> String.split("$")
      }
    end)
    |> Enum.filter(fn {name, _} -> String.contains?(name, "blue") end)
    |> (fn [{_, [_, buy_price, sell_price]}] -> {buy_price, sell_price} end).()
    |> Tools.FloatUtils.parse_string_tuple()
  end
end
