defmodule RaffleyWeb.AdminRafflelive.Index do
  use RaffleyWeb, :live_view
  alias Raffley.Admin

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Listing Raffles")
      |> stream(:raffles, Admin.list_raffles())

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="admin-index">
      <.header>
        <:actions>
          <.link class="button" navigate={~p"/admin/raffles/new"}>
            New Raffle
          </.link>
        </:actions>
        {@page_title}
      </.header>
      <.table id="raffles-list" rows={@streams.raffles}>
        <:col :let={{_id, raffle}} label="Prize">
          <.link navigate={~p"/raffleylist/#{raffle.id}"}>
            {raffle.prize}
          </.link>
        </:col>
        <:col :let={{_id, raffle}} label="Status">
          <RaffleyWeb.Components.CustomComponents.badge status={raffle.status} />
        </:col>
        <:col :let={{_id, raffle}} label="Ticket Price">
          {raffle.ticket_price}$
        </:col>
        <:col :let={{_id, raffle}} label="Prize">
          <.link navigate={~p"/admin/raffles/edit/#{raffle.id}"}>
            edit
          </.link>
        </:col>
      </.table>
    </div>
    """
  end
end
