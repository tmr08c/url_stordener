defmodule UrlStordener.Stats.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    belongs_to :url_mapping, UrlStordener.Shortener.UrlMapping

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:url_mapping_id])
    |> validate_required([:url_mapping_id])
    |> assoc_constraint(:url_mapping)
  end
end
