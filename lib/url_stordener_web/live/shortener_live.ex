defmodule UrlStordenerWeb.ShortenerLive do
  use UrlStordenerWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, url_mapper: %{})}
  end

  def handle_event("generate", %{"url_mapper" => params}, socket) do
    {:noreply, assign(socket, url_mapper: url_mapper_changeset(params))}
  end

  def render(assigns) do
    ~H"""
    <.simple_form
      :let={f}
      for={@url_mapper}
      as="url_mapper"
      id="phx-url-mapper-form"
      phx-submit="generate"
    >
      <.input field={f[:destination_url]} />

      <:actions>
        <.button>Shorten!</.button>
      </:actions>
    </.simple_form>
    """
  end

  def url_mapper_changeset(params \\ %{}) do
    types = %{destination_url: :string}

    {%{}, types}
    |> Ecto.Changeset.cast(params, Map.keys(types))
    |> Ecto.Changeset.validate_required(Map.keys(types))
    |> Map.put(:action, :validate)
  end
end
