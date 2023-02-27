defmodule UrlStordener.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :url_mapping_id, references(:url_mappings, on_delete: :nothing)

      timestamps()
    end

    create index(:events, [:url_mapping_id])
  end
end
