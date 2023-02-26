defmodule UrlStordener.Stats do
  import Ecto.Query

  alias UrlStordener.{Repo, Shortener.UrlMapping, Stats.Event}

  def mapping_stats do
    UrlMapping
    |> group_by(:id)
    |> join(:left, [u], e in assoc(u, :events))
    |> select([u, e], %{u | events: count(e)})
    |> Repo.all()
  end

  def create_event(mapping) do
    %Event{} |> Event.changeset(%{url_mapping_id: mapping.id}) |> Repo.insert()
  end
end
