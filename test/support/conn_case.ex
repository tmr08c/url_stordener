defmodule UrlStordenerWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use UrlStordenerWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # The default endpoint for testing
      @endpoint UrlStordenerWeb.Endpoint

      use UrlStordenerWeb, :verified_routes

      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import UrlStordenerWeb.ConnCase
      import UrlStordener.Factory

      # Find elements using the test-specific identifier pattern set up in
      # `UrlStordenerWeb.html_helper`
      defp tid(id), do: "[data-test-#{id}]"

      # RedirectController is leveraging Task.Supervisor to write events in
      # another process without waiting. In tests, this can cause a few problems:
      #
      # - the Event record may not be written after the redirect
      # - the test process may attempt to shutdown, releasing the checked out DB
      #   connection before the Task is done
      #
      # To circumvent these issues, this function will wait for the
      # TaskSupervisor's children to finish.
      defp wait_for_pending_event_writes() do
        for pending <- Task.Supervisor.children(UrlStordener.TaskSupervisor) do
          Process.monitor(pending)

          assert_receive({:DOWN, _, _, ^pending, _})
        end
      end
    end
  end

  setup tags do
    UrlStordener.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
