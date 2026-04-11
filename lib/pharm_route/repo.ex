defmodule PharmRoute.Repo do
  use Ecto.Repo,
    otp_app: :pharm_route,
    adapter: Ecto.Adapters.Postgres
end
