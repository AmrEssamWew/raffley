defmodule Raffley.Raffleies do
  alias Raffley.Raffles.Raffle
  alias Raffley.Repo
  import Ecto.Query

  def list_raffles, do: Repo.all(Raffle)
  def get_raffle!(id), do: Repo.get!(Raffle, id)

  def filter_raffles(filter) do
    Raffle
    |> with_status(filter["status"])
    |> search_by(filter["q"])
    |> sort(filter["sort_by"])
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

  defp with_status(query, status) when status in ~w(open upcoming closed ) do
    query |> where([r], r.status == ^status)
  end

  defp with_status(query, _) do
    query
  end

  defp search_by(query, value) when value != "",
    do: query |> where([r], ilike(r.prize, ^"%#{value}%"))

  defp search_by(query, _), do: query
  defp sort(query, "prize"), do: query |> order_by(:prize)
  defp sort(query, "ticket_price:asc"), do: query |> order_by(:ticket_price)
  defp sort(query, "ticket_price:dsc"), do: query |> order_by(desc: :ticket_price)
  defp sort(query, _), do: query |> order_by(desc: :id)
end
