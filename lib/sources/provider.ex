defmodule Dolarblue.Sources.Provider do
  def get_all do
    [
      Dolarblue.Sources.Ambito.get_source(),
      Dolarblue.Sources.Clarin.get_source(),
      Dolarblue.Sources.LaNacion.get_source(),
      Dolarblue.Sources.Agrofy.get_source()
    ]
  end
end
