defmodule Tools.FloatUtils do
  def parse_string(string) do
    Float.parse(string)
    |> (fn {float, _} -> float end).()
  end

  def parse_string_tuple(string_tuple) do
    Tuple.to_list(string_tuple)
    |> Enum.map(&parse_string(&1))
    |> List.to_tuple()
  end
end
