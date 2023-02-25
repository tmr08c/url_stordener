defmodule UrlStordenerWeb.ShortenerLiveTest do
  use UrlStordenerWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "new" do
    test "validate the destination URL", %{conn: conn} do
      {:ok, view, _} = live(conn, ~p"/")

      assert view |> element("form") |> render_submit(%{url_mapper: %{destination_url: ""}}) =~
               "can&#39;t be blank"

      assert view
             |> element("form")
             |> render_submit(%{url_mapper: %{destination_url: "not a URL"}}) =~
               "is not a valid URL"
    end

    test "generating a shortened URL", %{conn: conn} do
      {:ok, view, _} = live(conn, ~p"/")

      {:ok, _show_view, show_html} =
        view
        |> element("form")
        |> render_submit(%{url_mapper: %{destination_url: "http://www.example.com"}})
        |> follow_redirect(conn)

      assert show_html =~ "http://www.example.com"
      assert show_html =~ UrlStordenerWeb.Endpoint.url()
    end
  end
end
