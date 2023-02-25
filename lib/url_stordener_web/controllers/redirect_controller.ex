defmodule UrlStordenerWeb.RedirectController do
  use UrlStordenerWeb, :controller

  def show(conn, %{"slug" => _slug}) do
    conn |> put_status(301) |> redirect(external: "http://www.example.com")
  end
end
