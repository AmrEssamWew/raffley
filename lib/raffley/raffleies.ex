defmodule Raffley.Raffleies do
  alias Raffley.Raffles.Raffle
  alias Raffley.Repo
  import Ecto.Query

  def list_raffles, do: Repo.all(Raffle)
  def get_raffle!(id), do: Repo.get!(Raffle, id)

  def filter_raffles do
    Raffle
    |> where(status: :closed)
    |> order_by(:prize)
    |> Repo.all()
  end

  def featured_raffles(raffle) do
    Raffle
    |> where(status: :open)
    |> where([r], r.id != ^raffle.id)
    |> order_by(desc: :ticket_price)
    |> limit(3)
    |> Repo.all()
  end
end
