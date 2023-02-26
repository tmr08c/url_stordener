defmodule UrlStordenerWeb.RedirectController do
  use UrlStordenerWeb, :controller

  alias UrlStordener.Shortener

  def show(conn, %{"slug" => slug}) do
    %{destination_url: destination_url} = Shortener.get_url_mapping!(slug)
    conn |> put_status(301) |> redirect(external: destination_url)
  end
end
