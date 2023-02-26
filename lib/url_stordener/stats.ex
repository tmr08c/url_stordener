defmodule UrlStordener.Stats do
  alias UrlStordener.{Repo, Shortener.UrlMapping}

  def list_mappings do
    Repo.all(UrlMapping)
  end
end
