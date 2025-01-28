defmodule RaffleyWeb.Rafflelive.Index do
  use RaffleyWeb, :live_view
  alias Raffley.Raffleies
  alias RaffleyWeb.Components.CustomComponents

  def mount(_params, _session, socket) do
    socket = assign(socket, rafflelist: Raffleies.list_raffles(), page_title: "Raffles ")
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="raffle-index">
      <CustomComponents.banner :if={false}>
        <.icon name="hero-sparkles-solid" /> Mystery Raffle Coming Soon
        <:details :let={vibe}>
          To Be Revealed Tomorrow {vibe}
        </:details>
        <:details>
          Any Guesses ?
        </:details>
      </CustomComponents.banner>
      <div class="raffles">
        <CustomComponents.raffle_card :for={raffle <- @rafflelist} raffle={raffle} />
      </div>
    </div>
    """
  end
end
