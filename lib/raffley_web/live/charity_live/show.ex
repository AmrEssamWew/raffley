defmodule RaffleyWeb.CharityLive.Show do
  use RaffleyWeb, :live_view

  alias Raffley.Charities

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Charity {@charity.id}
      <:actions>
        <.link class="button" navigate={~p"/charities/#{@charity}/edit?return_to=show"}>
          Edit charity
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Name">{@charity.name}</:item>
      <:item title="Slug">{@charity.slug}</:item>
    </.list>
    <div class="mt-14">
      <h4>Featured Raffles</h4>
      <ul class="raffles">
        <li :for={raffle <- @charity.raffles}>
          <.link navigate={~p"/raffleylist/#{raffle.id}"}>
            <img src={raffle.image_path} /> {raffle.prize}
          </.link>
        </li>
      </ul>
    </div>
    <.back navigate={~p"/charities"}>Back to charities</.back>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Charity")
     |> assign(:charity, Charities.get_charity_with_assec(id))}
  end
end
