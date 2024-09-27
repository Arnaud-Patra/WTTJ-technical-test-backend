defmodule AtsWeb.PublicJobController do
  use AtsWeb, :controller

  alias Ats.Jobs
  alias Ats.Jobs.Job

  def index(conn, _params) do
    jobs = Jobs.list_jobs()
    # is_authenticated = False  # could be False by default
    is_authenticated = not is_nil(conn.assigns.current_user)
    office_options = Jobs.list_offices()
    render(conn, :index, jobs: jobs, office_options: office_options, is_authenticated: is_authenticated)
  end
end
