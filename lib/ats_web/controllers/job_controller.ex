defmodule AtsWeb.JobController do
  use AtsWeb, :controller

  alias Ats.Jobs
  alias Ats.Jobs.Job

  def job_list(conn, _params) do
    jobs = Jobs.list_jobs()
    render(conn, :job_list, jobs: jobs)
  end

  def index(conn, _params) do
    jobs = Jobs.list_jobs()
    render(conn, :index, jobs: jobs)
  end

  def new(conn, _params) do
    changeset = Jobs.change_job(%Job{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"job" => job_params}) do
    case Jobs.create_job(job_params) do
      {:ok, job} ->
        conn
        |> put_flash(:info, "Job created successfully.")
        |> redirect(to: ~p"/jobs/#{job}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    job = Jobs.get_job!(id)
    render(conn, :show, job: job)
  end

  def edit(conn, %{"id" => id}) do
    job = Jobs.get_job!(id)
    changeset = Jobs.change_job(job)
    render(conn, :edit, job: job, changeset: changeset)
  end

  def update(conn, %{"id" => id, "job" => job_params}) do
    job = Jobs.get_job!(id)

    case Jobs.update_job(job, job_params) do
      {:ok, job} ->
        conn
        |> put_flash(:info, "Job updated successfully.")
        |> redirect(to: ~p"/jobs/#{job}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, job: job, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    job = Jobs.get_job!(id)
    {:ok, _job} = Jobs.delete_job(job)

    conn
    |> put_flash(:info, "Job deleted successfully.")
    |> redirect(to: ~p"/jobs")
  end
end
