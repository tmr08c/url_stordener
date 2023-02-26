defmodule UrlStordenerWeb.StatsLive do
  use UrlStordenerWeb, :live_view

  alias UrlStordener.Stats

  def mount(_params, _session, socket) do
    {:ok, assign(socket, mappings: Stats.list_mappings())}
  end

  def render(assigns) do
    ~H"""
    <%= if @mappings == [] do %>
      No shortened URLs have been created yet.
      <.link navigate={~p"/"} class="font-semibold leading-6 text-zinc-900 hover:text-zinc-700">
        Create one!
      </.link>
    <% else %>
      <.table id="mappings" rows={@mappings}>
        <:col :let={mapping} label="Slug">
          <.slug_link slug={mapping.slug} />
        </:col>

        <:col :let={mapping} label="Destination">
          <.link navigate={mapping.destination_url}>
            <%= mapping.destination_url %>
          </.link>
        </:col>
      </.table>
    <% end %>
    """
  end
end
