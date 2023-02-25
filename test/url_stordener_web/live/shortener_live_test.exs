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
      destination = Faker.Internet.url()
      {:ok, view, _} = live(conn, ~p"/")

      {:ok, show_view, show_html} =
        view
        |> element("form")
        |> render_submit(%{url_mapper: %{destination_url: destination}})
        |> follow_redirect(conn)

      assert show_html =~ destination

      assert short =
               show_view
               |> element(tid("shortened-url"), UrlStordenerWeb.Endpoint.url())
               |> render()

      assert %{"slug" => slug} =
               Regex.named_captures(~r/#{UrlStordenerWeb.Endpoint.url()}\/(?<slug>\S+)\</, short)

      assert conn |> get("/#{slug}") |> redirected_to(301) == destination
    end
  end
end
