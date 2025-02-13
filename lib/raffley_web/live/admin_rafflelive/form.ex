defmodule RaffleyWeb.AdminRafflelive.Form do
  use RaffleyWeb, :live_view
  alias Raffley.Raffles.Raffle
  alias Raffley.Admin

  def mount(_params, _session, socket) do
    changeset = Raffle.changeset(%Raffle{}, %{})

    socket =
      socket
      |> assign(page_title: "New Raffle")
      |> assign(:form, to_form(changeset))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.header>
      {@page_title}
    </.header>
    <.simple_form for={@form} id="new_raffle" phx-submit="create" phx-change="validate">
      <.input field={@form[:prize]} label="Prize" />
      <pre>{inspect(@form.source.errors) }</pre>
      <.input label="Description" type="textarea" field={@form[:description]} />
      <.input
        label="status"
        field={@form[:status]}
        type="select"
        prompt="Choose a status"
        options={[:upcoming, :open, :closed]}
      />
      <.input label="Ticket Price" type="number" field={@form[:ticket_price]} />
      <.input label="Image Path" field={@form[:image_path]} />

      <:actions>
        <.button>Save</.button>
      </:actions>
    </.simple_form>
    <.back navigate={~p"/admin/raffles"}>
      back
    </.back>
    """
  end

  def handle_event("create", %{"raffle" => params}, socket) do
    case Admin.create_raffle(params) do
      {:ok, _raffle} ->
        socket =
          socket
          |> put_flash(:info, "Raffle created")
          |> push_navigate(to: ~p"/admin/raffles")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket =
          assign(socket, :form, to_form(changeset))
          |> put_flash(:error, "Raffle can't be created")

        {:noreply, socket}
    end
  end

  def handle_event("validate", %{"raffle" => params}, socket) do
    changeset = %{Admin.validate(params) | action: :validate}
    socket = assign(socket, :form, to_form(changeset))

    {:noreply, socket}
  end
end
