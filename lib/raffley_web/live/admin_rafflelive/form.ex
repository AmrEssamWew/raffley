defmodule RaffleyWeb.AdminRafflelive.Form do
  use RaffleyWeb, :live_view
  alias Raffley.Raffles.Raffle
  alias Raffley.Admin

  def mount(params, _session, socket) do
    socket = action_mount(socket, params)
    {:ok, socket}
  end

  defp action_mount(socket, _params) when socket.assigns.live_action == :new do
    raffle = %Raffle{}
    changeset = Raffle.changeset(raffle, %{})

    socket =
      socket
      |> assign(page_title: "New Raffle")
      |> assign(:form, to_form(changeset))
      |> assign(:can_you_catch_me, raffle)

    socket
  end

  defp action_mount(socket, %{"id" => id}) when socket.assigns.live_action == :edit do
    raffle = Admin.get_raffle!(id)
    changeset = Raffle.changeset(raffle, %{})

    socket =
      socket
      |> assign(page_title: "New Raffle")
      |> assign(:form, to_form(changeset))
      |> assign(:can_you_catch_me, raffle)

    socket
  end

  def render(assigns) do
    ~H"""
    <.header>
      {@page_title}
    </.header>
    <.simple_form for={@form} id="new_raffle" phx-submit="save" phx-change="validate">
      <.input field={@form[:prize]} label="Prize" />
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

  def handle_event("save", %{"raffle" => params}, socket) do
    IO.inspect(socket, label: "zewpew")
    socket = save_raffle(params, socket)
    {:noreply, socket}
  end

  def handle_event("validate", %{"raffle" => params}, socket) do
    changeset = %{Admin.validate(params) | action: :validate}
    socket = assign(socket, :form, to_form(changeset))

    {:noreply, socket}
  end

  defp save_raffle(params, socket) when socket.assigns.live_action == :new do
    case Admin.create_raffle(params) do
      {:ok, _raffle} ->
        socket =
          socket
          |> put_flash(:info, "Raffle edited")
          |> push_navigate(to: ~p"/admin/raffles")

        socket

      {:error, %Ecto.Changeset{} = changeset} ->
        socket =
          assign(socket, :form, to_form(changeset))
          |> put_flash(:error, "Raffle can't be edited")

        socket
    end
  end

  defp save_raffle(params, socket) when socket.assigns.live_action == :edit do
    case Admin.update_raffle(socket.assigns.can_you_catch_me, params) do
      {:ok, _raffle} ->
        socket =
          socket
          |> put_flash(:info, "Raffle created")
          |> push_navigate(to: ~p"/admin/raffles")

        socket

      {:error, %Ecto.Changeset{} = changeset} ->
        socket =
          assign(socket, :form, to_form(changeset))
          |> put_flash(:error, "Raffle can't be created")

        socket
    end
  end
end
