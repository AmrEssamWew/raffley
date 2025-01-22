defmodule RaffleyWeb.RulesController do
  use RaffleyWeb, :controller
  alias Raffley.Rules

  def index(conn, _opts) do
    rules = Rules.list_rules()
    render(conn, :index, rules: rules)
  end

  def show(conn, %{id: id}) do
    rule = Rules.find_rule(id)
    render(conn, :show, id: id)
  end
end
