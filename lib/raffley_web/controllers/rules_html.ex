defmodule RaffleyWeb.RulesHTML do
  use RaffleyWeb, :html
  embed_templates("rules_html/*")

  def show(sassigns) do
    ~H"""
    <div class="rules">
    <h1> Don't forget </h1>
    <p>
    {@rule.text}
    </p>
    """
  end
end
