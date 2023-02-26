defmodule UrlStordenerWeb.ShortenerLive.Show do
  use UrlStordenerWeb, :live_view

  alias UrlStordener.Shortener

  def mount(%{"slug" => slug}, _session, socket) do
    {:ok, assign(socket, url_mapping: Shortener.get_url_mapping!(slug))}
  end

  def render(assigns) do
    ~H"""
    <%= @url_mapping.destination_url %> -->
    <span {tid("shortened-url")}>
      <%= UrlStordenerWeb.Endpoint.url() <> "/" <> @url_mapping.slug %>
    </span>
    """
  end
end
