defmodule Dolarblue.ReportStore do
  use Agent

  @name __MODULE__

  #####
  # API

  def start_link(_) do
    Agent.start_link(fn -> %{timestamp: DateTime.utc_now(), update_success: %{}} end, name: @name)
  end

  def save_report(results) do
    report =
      results
      |> Enum.reduce(%{}, fn {source, data}, map -> Map.put(map, source, !is_nil(data)) end)

    Agent.update(@name, fn _ ->
      %{update_success: report, timestamp: DateTime.utc_now()}
    end)
  end

  def get_report() do
    Agent.get(@name, fn state -> state end)
  end
end
