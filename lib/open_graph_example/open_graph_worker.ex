defmodule OpenGraphExample.OpenGraphWorker do
  alias OpenGraphExample.OpenGraph

  @required_keys [:title, :type, :url, :image]

  def fetch(url) do
    opts = Application.get_env(:open_graph_example, :open_graph_req_options, [])

    with {:ok, response} <- Req.get(url, opts),
         {:ok, document} <- Floki.parse_document(response.body) do
      document
      |> get_attrs()
      |> OpenGraph.create()
    end
  end

  defp get_attrs(document) do
    Enum.into(@required_keys, %{}, fn key ->
      content =
        document
        |> Floki.attribute("meta[property=\"og:#{key}\"]", "content")
        |> List.first()

      {key, content}
    end)
  end
end
