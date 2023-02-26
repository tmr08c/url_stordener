defmodule UrlStordenerWeb.StatsLiveTest do
  use UrlStordenerWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "a useful message appears when there are no URL Mappings", %{conn: conn} do
    {:ok, _, html} = live(conn, ~p"/stats")

    assert html =~ "No shortened URLs"
  end

  test "a table of mappings are displayed showing shortened and destination URL", %{conn: conn} do
    mapping = insert!(:url_mapping)
    {:ok, _, html} = live(conn, ~p"/stats")

    assert html =~ mapping.destination_url
    assert html =~ UrlStordenerWeb.Endpoint.url() <> "/" <> mapping.slug
  end
end
