# Simplsitic factory module inspired by
# https://hexdocs.pm/ecto/test-factories.html
defmodule UrlStordener.Factory do
  alias UrlStordener.{Repo, Shortener, Stats}

  # Factories

  def build(:event) do
    %Stats.Event{url_mapping_id: build(:url_mapping).id}
  end

  def build(:url_mapping) do
    %Shortener.UrlMapping{
      destination_url: Faker.Internet.url(),
      slug: Faker.Internet.slug()
    }
  end

  # Convenience API

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end
end
