defmodule Raffley.Admin do
  alias Raffley.Raffles.Raffle
  alias Raffley.Repo
  import Ecto.Query

  def list_raffles do
    Raffle
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def create_raffle(attrs) do
    %Raffle{}
    |> Raffle.changeset(attrs)
    |> Repo.insert()
  end

  def get_raffle!(id) do
    Repo.get!(Raffle, id)
  end

  def validate(attrs) do
    %Raffle{}
    |> Raffle.changeset(attrs)
  end

  def update_raffle(raffle, attr) do
    Raffle.changeset(raffle, attr) |> Repo.update()
  end
end
