defmodule UrlStordener.Shortener.UrlMapping do
  use Ecto.Schema
  import Ecto.Changeset

  schema "url_mappings" do
    field :destination_url, :string
    field :slug, :string

    timestamps()
  end

  def create_changeset(destination_url) do
    %__MODULE__{}
    |> cast(%{destination_url: destination_url}, [:destination_url])
    |> validate_required([:destination_url])
    |> validate_url()
  end

  def changeset(url_mapping, attrs) do
    url_mapping
    |> cast(attrs, [:destination_url, :slug])
    |> validate_required([:destination_url, :slug])
    |> validate_url()
    |> unique_constraint(:slug)
  end

  # TODO It's probably worth having a few more tests for this In practice, I
  # would probably want to consider exploring an existing solution to harden my
  # approach. Consider reviewing:
  # https://elixirforum.com/t/please-how-do-you-validate-url-inputs-in-your-phoenix-projects-forms/28268/18
  defp validate_url(changeset) do
    with {:ok, url} <- fetch_change(changeset, :destination_url),
         uri <- URI.parse(url),
         true <- is_nil(uri.scheme) or is_nil(uri.host) do
      add_error(changeset, :destination_url, "is not a valid URL")
    else
      _ -> changeset
    end
  end
end
