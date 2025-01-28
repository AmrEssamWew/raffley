defmodule RaffleyWeb.EstimatorLive do
  use RaffleyWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        ticket: 0,
        price: 10,
        page_title: "Estimator"
      )

    if connected?(socket) do
      Process.send_after(self(), :update, 2000)
    end

    {:ok, socket, layout: {RaffleyWeb.Layouts, :simple}}
  end

  def render(assigns) do
    ~H"""
    <div class="estimator">
      <h1>Raffle Estimator</h1>
      <section>
        <button phx-click="add" phx-value-quantity="5">+</button>

        <div>
          {@ticket}
        </div>
        @
        <div>
          {@price}
        </div>
        =
        <div>
          {@ticket * @price}
        </div>
      </section>
      <form phx-submit="set-price">
        <label> Ticket Price : </label>
        <input type="number" name="price" value={@price} />
      </form>
    </div>
    """
  end

  def handle_event("add", %{"quantity" => quantity}, socket) do
    {:noreply, update(socket, :ticket, &(&1 + String.to_integer(quantity)))}
  end

  def handle_event("set-price", %{"price" => price}, socket) do
    {:noreply, update(socket, :price, fn _ -> String.to_integer(price) end)}
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 2000)
    {:noreply, update(socket, :ticket, &(&1 + 1))}
  end
end
