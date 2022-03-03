defmodule Structures.DolarblueData do
  @derive [Poison.Encoder]
  defstruct buy_price: 0.0, sell_price: 0.0, datetime: DateTime.utc_now()

  def build_dolarblue({buy_price, sell_price}) do
    build_dolarblue({buy_price, sell_price, DateTime.utc_now()})
  end

  def build_dolarblue({buy_price, sell_price, timestamp}) do
    %Structures.DolarblueData{
      sell_price: sell_price,
      buy_price: buy_price,
      datetime: timestamp
    }
  end
end
