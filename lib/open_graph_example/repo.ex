defmodule OpenGraphExample.Repo do
  use Ecto.Repo,
    otp_app: :open_graph_example,
    adapter: Ecto.Adapters.Postgres
end
