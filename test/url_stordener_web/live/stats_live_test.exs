defmodule UrlStordenerWeb.StatsLiveTest do
  use UrlStordenerWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "a useful message appears when there are no URL Mappings", %{conn: conn} do
    {:ok, _, html} = live(conn, ~p"/stats")

    assert html =~ "No shortened URLs"
  end

  test "a table of mappings are displayed showing shortened and destination URL", %{conn: conn} do
    mapping = insert!(:url_mapping)
    event_count = :rand.uniform(50)
    for _ <- 1..event_count, do: insert!(:event, url_mapping_id: mapping.id)

    {:ok, view, _html} = live(conn, ~p"/stats")

    html = view |> element("tr#url-mapping-#{mapping.id}") |> render

    assert html =~ mapping.destination_url
    assert html =~ UrlStordenerWeb.Endpoint.url() <> "/" <> mapping.slug
    assert html =~ Integer.to_string(event_count)
  end
end
