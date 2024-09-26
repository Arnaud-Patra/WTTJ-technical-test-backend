defmodule Ats.Applicants.Applicant do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ats.Candidates.Candidate
  alias Ats.Jobs.Job

  schema "applicants" do
    field :application_date, :date
    field :salary_expectation, :integer
    field :status, :string
    belongs_to :candidate, Candidate
    belongs_to :job, Job

    timestamps()
  end

  def new_changeset(attrs) do
    new_attrs =
      attrs
      |> Map.put("application_date", Date.to_string(Date.utc_today()))
      |> Map.put("status", "new")

    changeset(%__MODULE__{}, new_attrs)
  end

  @doc false
  def changeset(applicant, attrs) do
    applicant
    |> cast(attrs, [:application_date, :status, :salary_expectation, :job_id, :candidate_id])
    |> validate_required([:salary_expectation])
  end
end
