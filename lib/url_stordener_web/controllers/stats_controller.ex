defmodule UrlStordenerWeb.StatsController do
  use UrlStordenerWeb, :controller

  alias UrlStordener.Stats

  def index(conn, _) do
    rows =
      Enum.map(Stats.mapping_stats(), fn url_mapping ->
        [
          UrlStordenerWeb.Endpoint.url() <> "/" <> url_mapping.slug,
          url_mapping.destination_url,
          url_mapping.events
        ]
      end)

    csv = NimbleCSV.RFC4180.dump_to_iodata([~w[slug destination usage] | rows])

    send_download(conn, {:binary, csv}, filename: "stats.csv", content_type: "text/csv")
  end
end
