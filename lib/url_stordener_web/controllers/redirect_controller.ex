defmodule UrlStordenerWeb.RedirectController do
  use UrlStordenerWeb, :controller

  alias UrlStordener.{Shortener, Stats}

  def show(conn, %{"slug" => slug}) do
    mapping = Shortener.get_url_mapping!(slug)

    conn
    |> put_status(301)
    |> redirect(external: mapping.destination_url)
    |> tap(fn _ ->
      Task.Supervisor.start_child(UrlStordener.TaskSupervisor, fn ->
        Stats.create_event(mapping)
      end)
    end)
  end
end
