defmodule Mysolat.Repo do
  use Ecto.Repo,
    otp_app: :mysolat,
    adapter: Ecto.Adapters.Postgres
end
