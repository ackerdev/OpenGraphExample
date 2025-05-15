defmodule OpenGraphExample.OpenGraph do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias OpenGraphExample.Repo
  alias __MODULE__

  schema "open_graphs" do
    field :url, :string
    field :type, :string
    field :title, :string
    field :image, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(open_graph, attrs) do
    open_graph
    |> cast(attrs, [:title, :type, :url, :image])
    |> validate_required([:url, :type, :title, :image])
  end

  def list() do
    OpenGraph
    |> order_by(desc: :inserted_at, desc: :id)
    |> Repo.all()
  end

  def create(attrs) do
    %OpenGraph{}
    |> changeset(attrs)
    |> Repo.insert()
  end
end
