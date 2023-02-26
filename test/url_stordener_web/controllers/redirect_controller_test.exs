defmodule UrlStordenerWeb.RedirectControllerTest do
  use UrlStordenerWeb.ConnCase

  describe "GET /:slug" do
    test "a user is redirected to the destination URL when we have a mapping", %{conn: conn} do
      mapping = insert!(:url_mapping)

      assert conn |> get("/#{mapping.slug}") |> redirected_to(301) == mapping.destination_url
    end

    test "a user is redirected to the homepage if we don't have a mapping", %{conn: conn} do
      assert_error_sent 404, fn -> get(conn, ~p"/#{Ecto.UUID.generate()}") end
    end
  end
end
