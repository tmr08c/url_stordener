defmodule UrlStordenerWeb.RedirectControllerTest do
  use UrlStordenerWeb.ConnCase

  import Ecto.Query

  alias UrlStordener.Repo

  describe "GET /:slug" do
    test "a user is redirected to the destination URL when we have a mapping", %{conn: conn} do
      mapping = insert!(:url_mapping)

      assert conn |> get("/#{mapping.slug}") |> redirected_to(301) == mapping.destination_url
    end

    test "a new event record is created when a user is redirected", %{conn: conn} do
      %{id: mapping_id} = mapping = insert!(:url_mapping)

      get(conn, "/#{mapping.slug}")

      assert UrlStordener.Stats.Event
             |> where(url_mapping_id: ^mapping_id)
             |> Repo.aggregate(:count) == 1

      get(conn, "/#{mapping.slug}")
      get(conn, "/#{mapping.slug}")

      assert UrlStordener.Stats.Event
             |> where(url_mapping_id: ^mapping_id)
             |> Repo.aggregate(:count) == 3
    end

    test "a user is redirected to the homepage if we don't have a mapping", %{conn: conn} do
      assert_error_sent 404, fn -> get(conn, ~p"/#{Ecto.UUID.generate()}") end
    end
  end
end
