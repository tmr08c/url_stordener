defmodule UrlStordenerWeb.ShortenerLive.New do
  use UrlStordenerWeb, :live_view

  alias UrlStordener.Shortener

  def mount(_params, _session, socket) do
    {:ok, assign(socket, url_mapping: Shortener.change_url_mapping())}
  end

  def handle_event("generate", params, socket) do
    %{"url_mapping" => %{"destination_url" => destination_url}} = params

    case Shortener.create_url_mapping(destination_url) do
      {:ok, url_mapping} -> {:noreply, push_navigate(socket, to: ~p"/shorts/#{url_mapping.slug}")}
      {:error, changeset} -> {:noreply, assign(socket, url_mapping: changeset)}
    end
  end

  def render(assigns) do
    ~H"""
    <.header>
      Generate a New Shortened URL
      <:subtitle>
        Provide a URL and we will generated a shortened version that you can share more easily!
      </:subtitle>
    </.header>

    <.simple_form
      :let={f}
      for={@url_mapping}
      as="url_mapping"
      id="phx-url-mapper-form"
      phx-submit="generate"
    >
      <.input field={f[:destination_url]} placeholder="http://www.example.com" />

      <:actions>
        <.button class="w-full">Shorten!</.button>
      </:actions>
    </.simple_form>
    """
  end
end
