defmodule Ats.Jobs do
  @moduledoc """
  The Jobs context.
  """

  import Ecto.Query, warn: false
  alias Ats.Repo

  alias Ats.Jobs.Job
  alias Ats.Professions.Profession

  @contract_types %{
    FULL_TIME: "Full-Time",
    PART_TIME: "Part-Time",
    TEMPORARY: "Temporary",
    FREELANCE: "Freelance",
    INTERNSHIP: "Internship"
  }

  @doc """
  Returns a job contract type.

  ## Examples

      iex> contract_type(%Job{contract_type: "FULL_TIME"})
      "Full-Time"

  """
  def contract_type(job) do
    @contract_types[job.contract_type]
  end

  @doc """
  Returns a job profession name.

  ## Examples

      iex> profession_name(%Job{profession: %Profession{name: "Software Engineer"}})
      "Software Engineer"
  """
  def profession_name(%Job{profession: %Profession{name: profession_name}}) do
    profession_name
  end

  def profession_name(_job), do: ""

  @doc """
  Returns the list of jobs.

  ## Examples

      iex> list_jobs()
      [%Job{}, ...]

  """
  def list_jobs(params \\ %{}) do
    Job
    # |> filter_by_title(params["title"])
    |> filter_by_office(params["office"])
    |> filter_by_work_mode(params["work_mode"])
    |> Repo.all()
    |> Repo.preload(:profession)  # Uncomment if you need profession data
  end

  defp filter_by_title(query, title) when is_binary(title) and title != "" do
    where(query, [j], ilike(j.title, ^"%#{title}%"))
  end
  defp filter_by_title(query, _), do: query

  defp filter_by_office(query, office) when is_binary(office) and office != "" do
    where(query, [j], ilike(j.office, ^"%#{office}%"))
  end
  defp filter_by_office(query, _), do: query

  defp filter_by_work_mode(query, work_mode) when is_binary(work_mode) and work_mode not in ["", "any"] do
    work_mode_atom = String.to_existing_atom(String.downcase(work_mode))
    where(query, [j], j.work_mode == ^work_mode_atom)
  end
  defp filter_by_work_mode(query, _), do: query

  @doc """
  Gets a single job.

  Raises `Ecto.NoResultsError` if the Job does not exist.

  ## Examples

      iex> get_job!(123)
      %Job{}

      iex> get_job!(456)
      ** (Ecto.NoResultsError)

  """
  def get_job!(id), do: Repo.get!(Job, id) |> Repo.preload(applicants: [:candidate])

  @doc """
  Creates a job.

  ## Examples

      iex> create_job(%{field: value})
      {:ok, %Job{}}

      iex> create_job(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_job(attrs \\ %{}) do
    %Job{}
    |> Job.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a job.

  ## Examples

      iex> update_job(job, %{field: new_value})
      {:ok, %Job{}}

      iex> update_job(job, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_job(%Job{} = job, attrs) do
    job
    |> Job.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a job.

  ## Examples

      iex> delete_job(job)
      {:ok, %Job{}}

      iex> delete_job(job)
      {:error, %Ecto.Changeset{}}

  """
  def delete_job(%Job{} = job) do
    Repo.delete(job)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking job changes.

  ## Examples

      iex> change_job(job)
      %Ecto.Changeset{data: %Job{}}

  """
  def change_job(%Job{} = job, attrs \\ %{}) do
    Job.changeset(job, attrs)
  end
end
