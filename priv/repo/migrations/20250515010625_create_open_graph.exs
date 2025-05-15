defmodule OpenGraphExample.Repo.Migrations.CreateOpenGraph do
  use Ecto.Migration

  def change do
    create table(:open_graphs) do
      add :title, :string
      add :type, :string
      add :url, :string
      add :image, :string

      timestamps(type: :utc_datetime)
    end
  end
end
