defmodule RaffleyWeb.Rafflelive.Index do
  use RaffleyWeb, :live_view
  alias Raffley.Raffleies
  alias RaffleyWeb.Components.CustomComponents

  def mount(_params, _session, socket) do
    socket =
      stream(socket, :rafflelist, Raffleies.list_raffles())

    # IO.inspect(socket.assigns.streams.raffles, label: "MOUNT")
    IO.inspect(socket.assigns.streams.rafflelist, lable: "Before Render")

    socket =
      attach_hook(socket, :log_stream, :after_render, fn socket ->
        IO.inspect(socket.assigns.streams.rafflelist)
        socket
      end)

    #   attach_hook(socket, :log_stream, :after_render, fn
    #     socket ->
    #       IO.inspect(socket.assigns.streams.raffles, label: "AFTER RENDER")
    #       socket
    #   end)

    {:ok, assign(socket, page_title: "Raffles ")}
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
      <div class="raffles" id="raffles" phx-update="stream">
        <CustomComponents.raffle_card
          :for={{raffle_id, raffle} <- @streams.rafflelist}
          raffle={raffle}
          id={raffle_id}
        />
      </div>
    </div>
    """
  end
end
