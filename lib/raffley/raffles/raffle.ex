defmodule Raffley.Raffles.Raffle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "raffles" do
    field :status, Ecto.Enum, values: [:upcoming, :open, :closed], default: :upcoming
    field :description, :string
    field :text, :string
    field :prize, :string
    field :ticket_price, :integer, default: 1
    field :image_path, :string, default: "/images/placeholder.jpg"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(raffle, attrs) do
    raffle
    |> cast(attrs, [:prize, :description, :text, :ticket_price, :image_path, :status])
    |> validate_required([:prize, :description, :text, :ticket_price, :image_path, :status])
  end
end
