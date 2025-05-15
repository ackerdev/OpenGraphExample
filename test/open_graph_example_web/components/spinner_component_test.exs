defmodule OpenGraphExampleWeb.SpinnerComponentTest do
  alias OpenGraphExampleWeb.SpinnerComponent
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest

  test "spinner/1" do
    assert render_component(&SpinnerComponent.spinner/1, %{})
  end
end
