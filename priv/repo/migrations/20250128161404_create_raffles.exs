defmodule Raffley.Repo.Migrations.CreateRaffles do
  use Ecto.Migration

  def change do
    create table(:raffles) do
      add :prize, :string
      add :description, :string
      add :text, :string
      add :ticket_price, :integer
      add :image_path, :string
      add :status, :string

      timestamps(type: :utc_datetime)
    end
  end
end
