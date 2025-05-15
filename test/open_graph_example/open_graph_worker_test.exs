defmodule OpenGraphExample.OpenGraphWorkerTest do
  use OpenGraphExample.DataCase, async: true
  alias OpenGraphExample.OpenGraph
  alias OpenGraphExample.OpenGraphWorker

  test "Successfully fetches OpenGraph data from remote url and persists it to database" do
    Req.Test.stub(OpenGraphWorker, fn conn ->
      Req.Test.html(conn, """
      <html prefix="og: http://ogp.me/ns#">
        <head>
          <title>Luna Care: On-Demand Physical Therapy</title>
          <meta property="og:title" content="Luna Care - Physical therapy, delivered to you">
          <meta property="og:type" content="website">
          <meta property="og:url" content="https://www.getluna.com/">
          <meta property="og:image" content="https://www.getluna.com/assets/images/we_come_to_you.svg">
        </head>
      </html>
      """)
    end)

    assert {:ok,
            og = %OpenGraph{
              title: "Luna Care - Physical therapy, delivered to you",
              type: "website",
              url: "https://www.getluna.com/",
              image: "https://www.getluna.com/assets/images/we_come_to_you.svg"
            }} = OpenGraphWorker.fetch("https://www.getluna.com")

    assert Ecto.get_meta(og, :state) == :loaded
  end

  test "missing open graph data" do
    Req.Test.stub(OpenGraphWorker, fn conn ->
      Req.Test.html(conn, """
      <html>
        <head></head>
      </html>
      """)
    end)

    assert {:error, %Ecto.Changeset{}} = OpenGraphWorker.fetch("/")
  end

  test "transport error" do
    Req.Test.stub(OpenGraphWorker, fn conn ->
      Req.Test.transport_error(conn, :timeout)
    end)

    assert {:error, %Req.TransportError{reason: :timeout}}
  end
end
