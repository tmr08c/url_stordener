defmodule UrlStordenerWeb.ShortenerLive.Show do
  use UrlStordenerWeb, :live_view

  alias UrlStordener.Shortener

  def mount(%{"slug" => slug}, _session, socket) do
    {:ok, assign(socket, url_mapping: Shortener.get_url_mapping!(slug))}
  end

  def render(assigns) do
    ~H"""
    <.header>New Shortened URL Generated</.header>

    <div class="flex flex-col space-y-8 mt-10">
      <.input
        type="text"
        value={url(~p"/#{@url_mapping.slug}")}
        label="Your Short URL"
        name="shortened_url"
        disabled
        {tid("shortened-url")}
        id="js-shortened-url"
      />

      <.input
        type="text"
        value={@url_mapping.destination_url}
        label="Your Destination URL"
        name="destination_url"
        disabled
      />

      <.button
        type="button"
        phx-click={JS.dispatch("phx:copy", to: "#js-shortened-url")}
        class="flex justify-center items-center"
      >
        <Heroicons.clipboard_document outline class="h-4 w-4 mr-2" /> Copy Short URL
      </.button>
    </div>
    """
  end
end
