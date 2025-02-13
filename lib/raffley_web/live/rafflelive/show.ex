defmodule RaffleyWeb.Rafflelive.Show do
  use RaffleyWeb, :live_view
  alias Raffley.Raffleies

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    raffle = Raffleies.get_raffle!(id)

    socket =
      assign(socket,
        raffle: raffle,
        page_title: raffle.prize
      )
      |> assign_async(:featured_raffles, fn ->
        {:ok, %{featured_raffles: Raffleies.featured_raffles(raffle)}}
      end)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="raffle-show">
      <div class="raffle">
        <img src={@raffle.image_path} />
        <section>
          <RaffleyWeb.Components.CustomComponents.badge status={@raffle.status} />
          <header>
            <h2>{@raffle.prize}</h2>
            <div class="price">
              $ {@raffle.ticket_price}
            </div>
          </header>
          <div class="description">{@raffle.description}</div>
        </section>
      </div>
      <div class="activity">
        <div class="left"></div>
        <div class="right">
          <.featured_raffle raffles={@featured_raffles} />
        </div>
      </div>
    </div>
    """
  end

  def featured_raffle(assigns) do
    ~H"""
    <section>
      <.async_result :let={result} assign={@raffles}>
        <:loading>
          <div class="loading">
            <div class="spinner"></div>
          </div>
        </:loading>
        <:failed :let={{:error, reason}}>
          Error while loading : {reason}
        </:failed>

        <h4>Featured Raffles</h4>
        <ul class="raffles">
          <li :for={raffle <- result}>
            <.link navigate={~p"/raffleylist/#{raffle.id}"}>
              <img src={raffle.image_path} /> {raffle.prize}
            </.link>
          </li>
        </ul>
      </.async_result>
    </section>
    """
  end
end
