defmodule OpenGraphExampleWeb.OpenGraphComponentTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  alias OpenGraphExampleWeb.OpenGraphComponent
  alias OpenGraphExample.OpenGraph

  test "open_graph/1" do
    assigns = %{
      id: "open_graphs-1",
      data: %OpenGraph{
        id: 1,
        title: "Luna Care - Physical therapy, delivered to you",
        type: "website",
        url: "https://www.getluna.com/",
        image: "https://www.getluna.com/assets/images/we_come_to_you.svg"
      }
    }

    component = render_component(&OpenGraphComponent.open_graph/1, assigns)
    assert component =~ "Luna Care - Physical therapy, delivered to you"
    assert component =~ "<img src=\"https://www.getluna.com/assets/images/we_come_to_you.svg\">"
  end
end
