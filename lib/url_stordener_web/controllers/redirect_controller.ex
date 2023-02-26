defmodule UrlStordenerWeb.RedirectController do
  use UrlStordenerWeb, :controller

  alias UrlStordener.{Shortener, Stats}

  def show(conn, %{"slug" => slug}) do
    mapping = Shortener.get_url_mapping!(slug)
    Stats.create_event(mapping)

    conn |> put_status(301) |> redirect(external: mapping.destination_url)
  end
end
