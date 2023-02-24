defmodule UrlStordenerWeb.ShortenerLiveTest do
  use UrlStordenerWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "validate the destination URL", %{conn: conn} do
    {:ok, view, _} = live(conn, ~p"/")

    assert view |> element("form") |> render_submit(%{url_mapper: %{destination_url: ""}}) =~
             "can&#39;t be blank"

    assert view
           |> element("form")
           |> render_submit(%{url_mapper: %{destination_url: "not a URL"}}) =~
             "is not a valid URL"

    refute view
           |> element("form")
           |> render_submit(%{
             url_mapper: %{
               destination_url:
                 "https://www.google.com/search?q=url+shortener&oq=google+u&aqs=chrome.0.69
i59j69i60l3j0j69i57.1069j0j7&sourceid=chrome&ie=UTF-8"
             }
           }) =~
             "is not a valid URL"
  end
end
