defmodule FgAuth.Repo do
  use Ecto.Repo,
    otp_app: :fg_auth,
    adapter: Ecto.Adapters.Postgres
end
