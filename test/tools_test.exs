defmodule ToolsTest do
  use ExUnit.Case

  alias Tools.DolarblueUtils, as: DU
  alias Tools.FloatUtils, as: FU
  alias Structures.DolarblueData, as: DolarblueData
  # Float utils tests

  test "float utils" do
    assert FU.parse_string("6.7") == 6.7
    assert FU.parse_string_tuple({"1", "2.4", "5.653"}) == {1, 2.4, 5.653}
  end

  # Dolarblue utils test
  test "test age filter" do
    old_date =
      DateTime.from_iso8601("2022-03-02 13:30:00Z")
      |> (fn {_, date, _} -> date end).()

    dolarblue_list = [
      {"old_source", DolarblueData.build_dolarblue({200, 200, old_date})},
      {"new_source", DolarblueData.build_dolarblue({200, 210})}
    ]

    filtered_list =
      dolarblue_list
      |> DU.filter_by_age(DateTime.utc_now(), 86400)

    assert length(dolarblue_list) > length(filtered_list)
    assert length(filtered_list) == 1
  end

  test "test average calculator" do
    dolarblue_list = [
      {"two", DolarblueData.build_dolarblue({200, 150})},
      {"two", DolarblueData.build_dolarblue({300, 200})},
      {"three", DolarblueData.build_dolarblue({400, 250})}
    ]

    {buy_average, sell_average} = DU.calculate_average(dolarblue_list)

    assert buy_average == 300
    assert sell_average == 200
  end
end
