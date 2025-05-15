defmodule OpenGraphExampleWeb.OpenGraphComponent do
  use Phoenix.Component
  alias OpenGraphExample.OpenGraph

  attr :id, :string, required: true
  attr :data, OpenGraph, required: true

  def open_graph(assigns) do
    ~H"""
    <a
      id={@id}
      href={@data.url}
      class="block m-2 p-4 rounded-xl shadow-lg bg-white border border-neutral"
    >
      <img src={@data.image} />
      <span class="text-lg text-zinc-600">{@data.title}</span>
    </a>
    """
  end
end
