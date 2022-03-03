defmodule Dolarblue.DataStore do
  use Agent

  @name __MODULE__

  #####
  # API

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: @name)
  end

  def save_data(results) do
    results
    |> Enum.filter(fn {_source, data} -> data != nil end)
    |> Enum.each(fn {source, data} -> store_dolarblue_data(source, data) end)
  end

  def store_dolarblue_data(source, data) do
    Agent.update(@name, &Map.update(&1, source, data, fn _ -> data end))
  end

  def get_data do
    Agent.get(@name, fn state -> state end)
  end
end
