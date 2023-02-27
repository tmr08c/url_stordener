defmodule UrlStordenerWeb.StatsLive do
  use UrlStordenerWeb, :live_view

  alias UrlStordener.Stats

  def mount(_params, _session, socket) do
    {:ok, assign(socket, mappings: Stats.mapping_stats())}
  end

  def render(assigns) do
    ~H"""
    <%= if @mappings == [] do %>
      No shortened URLs have been created yet.
      <.link navigate={~p"/"} class="font-semibold leading-6 text-zinc-900 hover:text-zinc-700">
        Create one!
      </.link>
    <% else %>
      <.link
        href={~p"/stats/download"}
        download
        class="text-xs float-right mb-6 flex"
        {tid("download-link")}
      >
        <Heroicons.document_arrow_down outline class="h-4 w-4 mr-1" /> Download
      </.link>

      <.table id="mappings" rows={@mappings} row_id={fn mapping -> "url-mapping-#{mapping.id}" end}>
        <:col :let={mapping} label="Slug">
          <.link navigate={~p"/#{mapping.slug}"}>
            <%= url(~p"/#{mapping.slug}") %>
          </.link>
        </:col>

        <:col :let={mapping} label="Destination">
          <.link navigate={mapping.destination_url}>
            <%= mapping.destination_url %>
          </.link>
        </:col>

        <:col :let={mapping} label="Usage">
          <%= mapping.events %>
        </:col>
      </.table>
    <% end %>
    """
  end
end
