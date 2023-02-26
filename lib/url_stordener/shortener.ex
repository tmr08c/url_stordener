defmodule UrlStordener.Shortener do
  alias UrlStordener.Repo
  alias UrlStordener.Shortener.UrlMapping

  def change_url_mapping() do
    UrlMapping.changeset(%UrlMapping{}, %{})
  end

  @slug_length 6
  def create_url_mapping(destination_url) do
    with %{valid?: true} = changeset <- UrlMapping.create_changeset(destination_url) do
      slug =
        :crypto.strong_rand_bytes(@slug_length)
        |> Base.url_encode64()
        |> binary_part(0, @slug_length)

      # TODO Think about handling unique constraint validation failure
      UrlMapping.changeset(changeset, %{"slug" => slug})
    end
    |> Repo.insert()
  end

  def get_url_mapping!(slug) do
    Repo.get_by!(UrlMapping, slug: slug)
  end
end
