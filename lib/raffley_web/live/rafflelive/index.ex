defmodule RaffleyWeb.Rafflelive.Index do
  use RaffleyWeb, :live_view
  alias Raffley.Raffleies
  alias RaffleyWeb.Components.CustomComponents
  alias Raffley.Raffles.Raffle

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        page_title: "Raffles"
      )

    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    new = Raffleies.filter_raffles(params)

    socket =
      socket
      |> assign(:form, to_form(params))
      |> stream(:rafflelist, new, reset: true)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="raffle-index">
      <.filter_form form={@form} />
      <CustomComponents.banner :if={false}>
        <.icon name="hero-sparkles-solid" /> Mystery Raffle Coming Soon
        <:details :let={vibe}>
          To Be Revealed Tomorrow {vibe}
        </:details>
        <:details>
          Any Guesses ?
        </:details>
      </CustomComponents.banner>
      <div class="raffles" id="raffles">
        <div id="empty" class="no-results only:block hidden">
          No raffles found. Try changing your filters.
        </div>

        <CustomComponents.raffle_card
          :for={{raffle_id, raffle} <- @streams.rafflelist}
          raffle={raffle}
          id={raffle_id}
        />
      </div>
    </div>
    """
  end

  def filter_form(assigns) do
    ~H"""
    <.form for={@form} id="filter_form" phx-change="filter">
      <.input placeholder="search..." field={@form[:q]} autocomplete="off" phx-debounce="2000" />
      <.input
        type="select"
        prompt="status"
        options={Ecto.Enum.values(Raffle, :status)}
        field={@form[:status]}
      />
      <.input
        type="select"
        prompt="sort by"
        options={[
          prize: "prize",
          "ticket price: low to high": "ticket_price:asc",
          "ticket price: high to low": "ticket_price:dsc"
        ]}
        field={@form[:sort_by]}
      />
    </.form>
    """
  end

  def handle_event("filter", params, socket) do
    params =
      params
      |> Map.take(~w(q status sort_by))
      |> Map.reject(fn {_, v} -> v == "" end)

    socket = push_patch(socket, to: ~p"/raffleylist?#{params}")
    {:noreply, socket}
  end
end
