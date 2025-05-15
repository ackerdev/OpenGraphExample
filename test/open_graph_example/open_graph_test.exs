defmodule OpenGraphExample.OpenGraphTest do
  use OpenGraphExample.DataCase, async: true
  alias OpenGraphExample.OpenGraph

  test "create/1" do
    assert {:ok, open_graph} =
             OpenGraph.create(%{
               title: "Luna Care - Physical therapy, delivered to you",
               type: "website",
               url: "https://www.getluna.com/",
               image: "https://www.getluna.com/assets/images/we_come_to_you.svg"
             })

    assert %OpenGraph{
             title: "Luna Care - Physical therapy, delivered to you",
             type: "website",
             url: "https://www.getluna.com/",
             image: "https://www.getluna.com/assets/images/we_come_to_you.svg"
           } = open_graph

    assert Ecto.get_meta(open_graph, :state) == :loaded
  end

  test "list/1" do
    {:ok, open_graph_1} =
      OpenGraph.create(%{
        title: "Luna Care - Physical therapy, delivered to you",
        type: "website",
        url: "https://www.getluna.com/",
        image: "https://www.getluna.com/assets/images/we_come_to_you.svg"
      })

    {:ok, open_graph_2} =
      OpenGraph.create(%{
        title: "The Rock",
        type: "video.movie",
        url: "https://www.imdb.com/title/tt0117500/",
        image: "https://ia.media-imdb.com/images/rock.jpg"
      })

    assert [open_graph_2, open_graph_1] == OpenGraph.list()
  end
end
