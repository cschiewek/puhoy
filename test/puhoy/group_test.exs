defmodule PuhoyGroupTest do
  use ExUnit.Case
  alias Puhoy.Group
  doctest Puhoy

  test "struct" do
    assert %Group{} |> Map.keys == [:__struct__, :high, :low, :name, :number]
  end

  test "from_response" do
    assert Group.from_response("211 1234 3000234 3002322 misc.test") ==
      %Group{high: 3002322, low: 3000234, name: "misc.test", number: 1234, name: "misc.test" }
  end
end
