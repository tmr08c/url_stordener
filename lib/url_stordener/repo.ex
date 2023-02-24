defmodule UrlStordener.Repo do
  use Ecto.Repo,
    otp_app: :url_stordener,
    adapter: Ecto.Adapters.Postgres
end
