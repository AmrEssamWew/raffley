defmodule Raffley.Rules do
  def list_rules do
    [
      %{id: 1, text: "Keep It Clear and Concise"},
      %{id: 2, text: "Make It Scannable"},
      %{id: 3, text: "Engage with Visual Elements"}
    ]
  end

  def find_rule(id) when is_integer(id) do
    list_rules() |> Enum.find(&(&1.id == id))
  end

  def find_rule(id) when is_binary(id) do
    id |> String.to_integer() |> find_rule()
    
  end
end
