defmodule Screen.Repo do
  use Ecto.Repo,
    otp_app: :screen,
    adapter: Ecto.Adapters.SQLite3
end
