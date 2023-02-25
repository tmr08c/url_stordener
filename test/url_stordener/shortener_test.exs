defmodule UrlStordener.ShortenerTest do
  use UrlStordener.DataCase, async: true

  alias UrlStordener.Shortener

  describe "create_url_mapping/1" do
    test "requires a valid URL" do
      assert {:error, changeset} = Shortener.create_url_mapping(nil)
      assert "can't be blank" in errors_on(changeset).destination_url

      assert {:error, changeset} = Shortener.create_url_mapping("")
      assert "can't be blank" in errors_on(changeset).destination_url

      assert {:error, changeset} = Shortener.create_url_mapping("foo")
      assert "is not a valid URL" in errors_on(changeset).destination_url
    end

    test "unique slugs are randomly auto-generated" do
      assert {:ok, %{slug: slug1}} = Shortener.create_url_mapping("http://wwww.example.com")
      assert {:ok, %{slug: slug2}} = Shortener.create_url_mapping("http://wwww.example.com")
      refute slug1 == slug2
    end
  end
end