defmodule UrlStordener.Shortener do
  alias UrlStordener.Repo
  alias UrlStordener.Shortener.UrlMapping

  def change_url_mapping() do
    UrlMapping.changeset(%UrlMapping{}, %{})
  end

  @slug_length 6
  def create_url_mapping(destination_url, retry_count \\ 0, slug \\ nil) do
    with %{valid?: true} = changeset <- UrlMapping.create_changeset(destination_url) do
      slug =
        slug ||
          :crypto.strong_rand_bytes(@slug_length)
          |> Base.url_encode64()
          |> binary_part(0, @slug_length)

      UrlMapping.changeset(changeset, %{"slug" => slug})
    end
    |> Repo.insert()
    |> then(fn
      # If we are within our retry_count limit and only have an error due to a
      # non-unique slug, we will retry the creation process, generating a new
      # constraint
      {:error, %{errors: errors}} = resp when length(errors) == 1 and retry_count < 3 ->
        with {_msg, opts} <- errors[:slug],
             true <- Keyword.get(opts, :constraint) == :unique do
          create_url_mapping(destination_url, retry_count + 1)
        else
          _ ->
            resp
        end

      resp ->
        resp
    end)
  end

  def get_url_mapping!(slug) do
    Repo.get_by!(UrlMapping, slug: slug)
  end
end
