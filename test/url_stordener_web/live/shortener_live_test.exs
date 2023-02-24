defmodule UrlStordenerWeb.ShortenerLiveTest do
  use UrlStordenerWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "generating a shortened URL", %{conn: conn} do
    {:ok, view, _} = live(conn, ~p"/")

    assert view |> element("form") |> render_submit(%{url_mapper: %{destination_url: ""}}) =~
             "blank"
  end
end
