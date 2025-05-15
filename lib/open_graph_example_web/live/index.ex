defmodule OpenGraphExampleWeb.Live.OpenGraphInspector do
  use OpenGraphExampleWeb, :live_view
  import OpenGraphExampleWeb.OpenGraphComponent
  import OpenGraphExampleWeb.SpinnerComponent
  alias OpenGraphExample.OpenGraph
  alias OpenGraphExample.OpenGraphWorker
  alias OpenGraphExample.OpenGraphWorkerSupervisor

  def mount(_, _, socket) do
    socket =
      socket
      |> assign(:form, to_form(init_form_fields()))
      |> stream_configure(:processing_urls, dom_id: & &1)
      |> stream(:processing_urls, [])
      |> stream(:open_graphs, OpenGraph.list())

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.simple_form
      for={@form}
      phx-submit="fetch"
      phx-change="change"
      id="open-graph-input"
      class="w-full"
    >
      <.input field={@form["url"]} placeholder="Enter a URL" type="url" required />
      <.button>Fetch</.button>
    </.simple_form>
    <div id="processing-open-graphs" phx-update="stream" class="w-full flex flex-col items-center m-4">
      <div
        :for={{dom_id, url} <- @streams.processing_urls}
        id={dom_id}
        class="bg-gray-300 rounded-xl p-4"
      >
        <.spinner class="text-blue-600 inline" />
        <span class="text-zinc-600">{url}</span>
      </div>
    </div>
    <div id="open-graphs" phx-update="stream" class="w-full flex flex-col items-center">
      <.open_graph :for={{dom_id, data} <- @streams.open_graphs} id={dom_id} data={data} />
    </div>
    """
  end

  def handle_event("change", params, socket) do
    {:noreply, assign(socket, :form, params)}
  end

  def handle_event("fetch", %{"url" => url}, socket) do
    socket =
      socket
      |> assign(:form, to_form(init_form_fields()))
      |> stream_insert(:processing_urls, url)
      |> start_async(:fetch_open_graph, fn -> {url, OpenGraphWorker.fetch(url)} end,
        supervisor: OpenGraphWorkerSupervisor
      )

    {:noreply, socket}
  end

  def handle_async(:fetch_open_graph, {:ok, {url, result}}, socket) do
    socket = stream_delete(socket, :processing_urls, url)

    case result do
      {:ok, open_graph} ->
        {:noreply, stream_insert(socket, :open_graphs, open_graph, at: 0)}

      {:error, error} ->
        error_msg =
          case error do
            %Req.TransportError{} -> "There was an error communicating with the server."
            %Ecto.Changeset{} -> "OpenGraph data was malformed or missing."
          end

        {:noreply, put_flash(socket, :error, error_msg)}
    end
  end

  defp init_form_fields, do: %{"url" => ""}
end
