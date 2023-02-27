defmodule UrlStordenerWeb.RedirectControllerTest do
  use UrlStordenerWeb.ConnCase, async: false

  import Ecto.Query

  alias UrlStordener.Repo

  describe "GET /:slug" do
    test "a user is redirected to the destination URL when we have a mapping", %{conn: conn} do
      mapping = insert!(:url_mapping)

      assert conn |> get(~p"/#{mapping.slug}") |> redirected_to(301) == mapping.destination_url
      wait_for_pending_event_writes()
    end

    test "a new event record is created when a user is redirected", %{conn: conn} do
      Phoenix.PubSub.subscribe(UrlStordener.PubSub, "events")

      %{id: mapping_id} = mapping = insert!(:url_mapping)

      get(conn, ~p"/#{mapping.slug}")
      wait_for_pending_event_writes()

      assert UrlStordener.Stats.Event
             |> where(url_mapping_id: ^mapping_id)
             |> Repo.aggregate(:count) == 1

      get(conn, ~p"/#{mapping.slug}")
      get(conn, ~p"/#{mapping.slug}")

      wait_for_pending_event_writes()

      assert UrlStordener.Stats.Event
             |> where(url_mapping_id: ^mapping_id)
             |> Repo.aggregate(:count) == 3
    end

    test "a user is redirected to the homepage if we don't have a mapping", %{conn: conn} do
      assert_error_sent 404, fn -> get(conn, ~p"/#{Ecto.UUID.generate()}") end
    end
  end
end
