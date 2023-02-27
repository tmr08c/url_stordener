defmodule UrlStordenerWeb.StatsControllerTest do
  use UrlStordenerWeb.ConnCase, async: true

  describe "GET /stats/download" do
    test "rows contain the mapping slug, destination, and number of uses", %{conn: conn} do
      mapping1 = insert!(:url_mapping)

      for _ <- 1..5, do: insert!(:event, url_mapping_id: mapping1.id)

      assert [mapping1_row] =
               conn
               |> get(~p"/stats/download")
               |> Map.fetch!(:resp_body)
               |> NimbleCSV.RFC4180.parse_string()

      assert [url(~p"/#{mapping1.slug}"), mapping1.destination_url, "5"] == mapping1_row
    end

    test "there is a row for each mapping", %{conn: conn} do
      for _ <- 1..10, do: insert!(:url_mapping)

      mappings =
        conn
        |> get(~p"/stats/download")
        |> Map.fetch!(:resp_body)
        |> NimbleCSV.RFC4180.parse_string()

      assert length(mappings) == 10
    end
  end
end
