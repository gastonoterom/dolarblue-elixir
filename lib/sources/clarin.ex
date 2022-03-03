defmodule Dolarblue.Sources.Clarin do
  @link "https://www.clarin.com/economia/divisas-acciones-bonos/"

  def get_source do
    {"clarin", &fetch_values/0}
  end

  def fetch_values() do
    HTTPoison.get!(@link)
    |> (fn response -> Floki.parse_document(response.body) end).()
    |> (fn {_, document} -> get_dolar_values(document) end).()
    |> Structures.DolarblueData.build_dolarblue()
  end

  defp get_dolar_values(document) do
    document
    |> Floki.find("table")
    |> Floki.find(".updown")
    |> Enum.filter(fn table ->
      Floki.find(table, "h3") |> Floki.text() == "Dólar blue"
    end)
    |> (fn [dolarblue_table] ->
          {
            Floki.find(dolarblue_table, ".last") |> Floki.text(),
            Floki.find(dolarblue_table, "#monedaUSD") |> Floki.text()
          }
        end).()
    |> (fn {buy_price, sell_price} ->
          {
            String.replace(buy_price, "$", ""),
            String.replace(sell_price, "$", "")
          }
        end).()
    |> Tools.FloatUtils.parse_string_tuple()
  end
end
