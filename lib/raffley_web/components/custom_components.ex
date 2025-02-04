defmodule RaffleyWeb.Components.CustomComponents do
  use RaffleyWeb, :html

  def badge(assigns) do
    ~H"""
    <div class={[
      "rounded-md px-2 py-1 text-xs font-medium uppercase inline-block border ",
      @status == :open && "text-lime-600 border-lime-600",
      @status == :upcoming && "text-amber-600 border-amber-600",
      @status == :close && "text-gray-600 border-gray-600"
    ]}>
      {@status}
    </div>
    """
  end

  def raffle_card(assigns) do
    ~H"""
    <div :if={@raffle != %{}} class="card">
      <.link navigate={~p"/raffleylist/#{@raffle.id}"} id={@id}>
        <img src={@raffle.image_path} />
        <h2>{@raffle.prize}</h2>
        <div class="details">
          <div class="price">
            ${@raffle.ticket_price} / ticket
          </div>
          <.badge status={@raffle.status} />
        </div>
      </.link>
    </div>
    """
  end

  slot :inner_block, required: true
  slot :details

  def banner(assigns) do
    assigns = assign(assigns, :emoj, ~w(🥸 🤯 🫨) |> Enum.random())

    ~H"""
    <div class="banner">
      <h1>
        {render_slot(@inner_block)}
      </h1>
      <div :for={details <- @details} class="details">
        {render_slot(details, @emoj)}
      </div>
    </div>
    """
  end
end
