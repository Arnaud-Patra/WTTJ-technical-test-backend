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
  Returns the list of jobs. The user can filter the jobs by title, office and work mode.
  By default, all jobs are returned.
  ## Examples

      iex> list_jobs(%{"title" => "Software Engineer", "office" => "Paris", "work_mode" => "remote"})
      [%Job{}, ...]
  """
  def list_jobs(params \\ %{}, is_authenticated \\ false) do
    Job
    |> filter_by_title(params["title"])
    |> filter_by_office(params["office"])
    |> filter_by_work_mode(params["work_mode"])
    |> filter_by_contract_type(params["contract_type"])
    |> filter_by_authentication(is_authenticated)
    |> Repo.all()
    |> Repo.preload(:profession)
  end

  defp filter_by_authentication(query, true), do: query
  defp filter_by_authentication(query, false) do
    where(query, [j], j.status == :published)
  end

  defp filter_by_title(query, title) when is_binary(title) and title != "" do
    where(query, [j], ilike(j.title, ^"%#{title}%"))
  end
  defp filter_by_title(query, _), do: query

  @doc """
  Returns the list of unique offices
  ## Examples

      iex> list_offices()
      ["Paris", "London", "Berlin", ...]

  """
  def list_offices do
    Ats.Repo.all(from j in Ats.Jobs.Job, distinct: true, select: j.office)
  end

  defp filter_by_office(query, office) when is_binary(office) and office != "" do
    where(query, [j], ilike(j.office, ^"%#{office}%"))
  end
  defp filter_by_office(query, _), do: query

  defp filter_by_work_mode(query, work_mode) when is_binary(work_mode) and work_mode not in ["", "any"] do
    work_mode_atom = String.to_existing_atom(String.downcase(work_mode))
    where(query, [j], j.work_mode == ^work_mode_atom)
  end
  defp filter_by_work_mode(query, _), do: query


  defp filter_by_contract_type(query, nil), do: query
  defp filter_by_contract_type(query, contract_type) when is_binary(contract_type) do
    contract_type_atom = String.to_existing_atom(contract_type)

    if contract_type_atom in Job.contract_types() do
      where(query, [j], j.contract_type == ^contract_type_atom)
    else
      query
    end
  end
  defp filter_by_contract_type(query, _), do: query  # Invalid contract type, return unfiltered query

  @spec get_job!(any()) :: nil | [%{optional(atom()) => any()}] | %{optional(atom()) => any()}
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
