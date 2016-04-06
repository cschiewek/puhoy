defmodule Puhoy.Group do
  defstruct [:name, :number, :low, :high]

  def from_response(response) do
    list = response |> String.strip |> String.split 
    %__MODULE__{
      number: list |> Enum.at(1) |> String.to_integer,
      low: list |> Enum.at(2) |> String.to_integer,
      high: list |> Enum.at(3) |> String.to_integer,
      name: list |> Enum.at(4)
    }
  end
end
