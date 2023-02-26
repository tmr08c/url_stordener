defmodule UrlStordener.Stats do
  alias UrlStordener.{Repo, Shortener.UrlMapping, Stats.Event}

  def list_mappings do
    Repo.all(UrlMapping)
  end

  def create_event(mapping) do
    %Event{} |> Event.changeset(%{url_mapping_id: mapping.id}) |> Repo.insert()
  end
end
