defmodule OpenGraphExampleWeb.Live.IndexTest do
  use OpenGraphExampleWeb.ConnCase, async: true
  import Phoenix.ConnTest
  import Phoenix.LiveViewTest
  alias OpenGraphExample.OpenGraph

  test "connected mount", %{conn: conn} do
    OpenGraph.create(%{
      title: "Luna Care - Physical therapy, delivered to you",
      type: "website",
      url: "https://www.getluna.com/",
      image: "https://www.getluna.com/assets/images/we_come_to_you.svg"
    })

    assert {:ok, _view, html} = live(conn, "/")
    assert html =~ "Luna Care - Physical therapy, delivered to you"
  end
end
