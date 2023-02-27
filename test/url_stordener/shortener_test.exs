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

      assert {:error, changeset} = Shortener.create_url_mapping("ftp://user@server.com")
      assert "is not a valid URL" in errors_on(changeset).destination_url

      assert {:ok, _} = Shortener.create_url_mapping("http://www.subdomain.example.com")
      assert {:ok, _} = Shortener.create_url_mapping("https://www.example.com/some/slug?q=yes")
    end

    test "unique slugs are randomly auto-generated" do
      assert {:ok, %{slug: slug1}} = Shortener.create_url_mapping("http://wwww.example.com")
      assert {:ok, %{slug: slug2}} = Shortener.create_url_mapping("http://wwww.example.com")
      refute slug1 == slug2
    end

    test "non-unique slugs will be auto-retried" do
      assert {:ok, _} = Shortener.create_url_mapping("http://www.example.com", 0, "foo")
      assert {:ok, _} = Shortener.create_url_mapping("http://www.example.com", 0, "foo")
      # exceeding retry count
      assert {:error, _} = Shortener.create_url_mapping("http://www.example.com", 3, "foo")
    end
  end

  test "get_url_mapping!/1 looks up URL mappings by slug" do
    assert_raise Ecto.NoResultsError, fn -> Shortener.get_url_mapping!(Ecto.UUID.generate()) end

    destination = Faker.Internet.url()
    %{slug: slug} = insert!(:url_mapping, destination_url: destination)
    assert %{destination_url: ^destination} = Shortener.get_url_mapping!(slug)
  end
end
