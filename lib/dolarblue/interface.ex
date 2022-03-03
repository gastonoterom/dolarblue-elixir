defmodule Dolarblue.Interface do
  def update() do
    Dolarblue.Fetcher.fetch()
  end

  def get_data() do
    Dolarblue.DataStore.get_data()
  end

  def get_average() do
    Dolarblue.AverageStore.get_average()
  end

  def get_report() do
    Dolarblue.ReportStore.get_report()
  end
end
