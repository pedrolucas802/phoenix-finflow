defmodule PhoenixFinflow.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_finflow,
    adapter: Ecto.Adapters.Postgres
end
