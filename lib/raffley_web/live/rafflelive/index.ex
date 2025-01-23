defmodule RaffleyWeb.Rafflelive.Index do
  use RaffleyWeb, :live_view
  alias Raffley.Raffleies

  def mount(_params, _session, socket) do
    socket = assign(socket, :rafflelist, Raffleies.list_raffles())
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="raffle-index">
      <div class="raffles">
        <.raffle_card :for={raffle <- @rafflelist} raffle={raffle} />
      </div>
    </div>
    """
  end

  attr :status, :atom, required: true, values: [:open, :upcoming, :closed]

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
    <div class="card">
      <img src={@raffle.image_path} />
      <h2>{@raffle.prize}</h2>
      <div class="details">
        <div class="price">
          ${@raffle.ticket_price} / ticket
        </div>
        <.badge status={@raffle.status} />
      </div>
    </div>
    """
  end
end
