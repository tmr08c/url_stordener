defmodule UrlStordenerWeb.AppComponents do
  @moduledoc """
  Provides app-specific UI components.
  """
  use Phoenix.Component

  use Phoenix.VerifiedRoutes,
    endpoint: UrlStordenerWeb.Endpoint,
    router: UrlStordenerWeb.Router,
    statics: UrlStordenerWeb.static_paths()

  @doc """
  Renders a link for a shortened URL, requiring only to have the slug.

  ## Examples

      <.slug_link slug="my-slug" />
  """
  attr :slug, :string, required: true
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the link container"

  def slug_link(assigns) do
    ~H"""
    <.link navigate={~p"/#{@slug}"} {@rest}>
      <%= UrlStordenerWeb.Endpoint.url() <> "/" <> @slug %>
    </.link>
    """
  end
end
