defmodule UrlStordenerWeb.ShortenerLive.New do
  use UrlStordenerWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, url_mapper: %{})}
  end

  def handle_event("generate", %{"url_mapper" => params}, socket) do
    url_mapper = url_mapper_changeset(params)

    if url_mapper.valid? do
      {:noreply, push_navigate(socket, to: ~p"/shorts/slug")}
    else
      {:noreply, assign(socket, url_mapper: url_mapper)}
    end
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

  defp url_mapper_changeset(params) do
    types = %{destination_url: :string}

    {%{}, types}
    |> Ecto.Changeset.cast(params, Map.keys(types))
    |> Ecto.Changeset.validate_required(Map.keys(types))
    |> validate_url()
    |> Map.put(:action, :validate)
  end

  # TODO It's probably worth having a few more tests for this In practice, I
  # would probably want to consider exploring an existing solution to harden my
  # approach. Consider reviewing:
  # https://elixirforum.com/t/please-how-do-you-validate-url-inputs-in-your-phoenix-projects-forms/28268/18
  defp validate_url(changeset) do
    with {:ok, url} <- Ecto.Changeset.fetch_change(changeset, :destination_url),
         uri <- URI.parse(url),
         true <- is_nil(uri.scheme) or is_nil(uri.host) do
      Ecto.Changeset.add_error(changeset, :destination_url, "is not a valid URL")
    else
      _ -> changeset
    end
  end
end
