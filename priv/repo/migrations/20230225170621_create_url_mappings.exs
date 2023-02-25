defmodule UrlStordener.Repo.Migrations.CreateUrlMappings do
  use Ecto.Migration

  def change do
    create table(:url_mappings) do
      add :destination_url, :string, null: false
      add :slug, :string, null: false

      timestamps()
    end

    create unique_index(:url_mappings, [:slug])
  end
end
