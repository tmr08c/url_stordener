defmodule UrlStordenerWeb.ShortenerLive.Show do
  use UrlStordenerWeb, :live_view

  def mount(%{"slug" => slug}, _session, socket) do
    {:ok, assign(socket, url_mapper: %{slug: slug, destination_url: "http://www.example.com"})}
  end

  def render(assigns) do
    ~H"""
    <%= @url_mapper.destination_url %> --> <%= UrlStordenerWeb.Endpoint.url() <> @url_mapper.slug %>
    """
  end
end
