defmodule Ats.JobsTest do
  use Ats.DataCase

  alias Ats.Jobs
  alias Ats.Jobs.Job
  alias Ats.Professions.Profession
  alias Ats.Professions

  describe "list_jobs/2" do
    setup do
      {:ok, profession} = Professions.create_profession(%{
        name: "Software Engineer",
        category_name: "Technology"
      })

      {:ok, _job1} = Jobs.create_job(%{
        title: "Senior Developer",
        office: "New York",
        work_mode: :remote,
        contract_type: :FULL_TIME,
        status: :published,
        profession_id: profession.id
      })
      {:ok, _job2} = Jobs.create_job(%{
        title: "Junior Developer",
        office: "London",
        work_mode: :onsite,  # Changed from :on_site to :onsite
        contract_type: :PART_TIME,
        status: :published,
        profession_id: profession.id
      })
      {:ok, _job3} = Jobs.create_job(%{
        title: "DevOps Engineer",
        office: "Berlin",
        work_mode: :hybrid,
        contract_type: :FULL_TIME,
        status: :draft,
        profession_id: profession.id
      })

      :ok
    end

    test "list_jobs/2 returns all published jobs when not authenticated" do
      jobs = Jobs.list_jobs()
      assert length(jobs) == 2
      assert Enum.all?(jobs, & &1.status == :published)
    end

    test "list_jobs/2 returns all jobs when authenticated" do
      jobs = Jobs.list_jobs(%{}, true)
      assert length(jobs) == 3
    end

    test "list_jobs/2 filters by title" do
      jobs = Jobs.list_jobs(%{"title" => "Senior"})
      assert length(jobs) == 1
      assert hd(jobs).title == "Senior Developer"
    end

    test "list_jobs/2 filters by office" do
      jobs = Jobs.list_jobs(%{"office" => "London"})
      assert length(jobs) == 1
      assert hd(jobs).office == "London"
    end

    test "list_jobs/2 filters by work_mode" do
      jobs = Jobs.list_jobs(%{"work_mode" => "remote"})
      assert length(jobs) == 1
      assert hd(jobs).work_mode == :remote
    end

    test "list_jobs/2 filters by contract_type" do
      jobs = Jobs.list_jobs(%{"contract_type" => "PART_TIME"})
      assert length(jobs) == 1
      assert hd(jobs).contract_type == :PART_TIME
    end

    test "list_jobs/2 applies multiple filters" do
      jobs = Jobs.list_jobs(%{"title" => "Developer", "work_mode" => "onsite"})
      assert length(jobs) == 1
      assert hd(jobs).title == "Junior Developer"
      assert hd(jobs).work_mode == :onsite
    end

    test "list_jobs/2 returns empty list for non-matching filters" do
      jobs = Jobs.list_jobs(%{"title" => "Non-existent Job"})
      assert jobs == []
    end
  end

  describe "jobs" do
    alias Ats.Jobs.Job

    import Ats.JobsFixtures

    @invalid_attrs %{
      contract_type: nil,
      description: nil,
      office: nil,
      status: nil,
      title: nil
    }

    test "get_job!/1 returns the job with given id" do
      job = job_fixture()
      assert Jobs.get_job!(job.id).id == job.id
    end

    test "create_job/1 with valid data creates a job" do
      valid_attrs = %{
        contract_type: "FULL_TIME",
        description: "Elixir dev backend",
        office: "Paris",
        status: "draft",
        title: "Dev Backend",
        work_mode: "onsite"
      }

      assert {:ok, %Job{} = job} = Jobs.create_job(valid_attrs)
      assert job.contract_type == :FULL_TIME
      assert job.description == "Elixir dev backend"
      assert job.office == "Paris"
      assert job.status == :draft
      assert job.title == "Dev Backend"
      assert job.work_mode == :onsite
    end

    test "create_job/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Jobs.create_job(@invalid_attrs)
    end

    test "update_job/2 with valid data updates the job" do
      job = job_fixture()

      update_attrs = %{
        contract_type: "PART_TIME",
        description: "Elixir dev backend senior",
        office: "Barcelone",
        status: "published",
        title: "Dev Backend",
        work_mode: "hybrid"
      }

      assert {:ok, %Job{} = job} = Jobs.update_job(job, update_attrs)
      assert job.contract_type == :PART_TIME
      assert job.description == "Elixir dev backend senior"
      assert job.office == "Barcelone"
      assert job.status == :published
      assert job.title == "Dev Backend"
      assert job.work_mode == :hybrid
    end

    test "update_job/2 with invalid data returns error changeset" do
      job = job_fixture()
      assert {:error, %Ecto.Changeset{}} = Jobs.update_job(job, @invalid_attrs)
      assert job.id == Jobs.get_job!(job.id).id
    end

    test "delete_job/1 deletes the job" do
      job = job_fixture()
      assert {:ok, %Job{}} = Jobs.delete_job(job)
      assert_raise Ecto.NoResultsError, fn -> Jobs.get_job!(job.id) end
    end

    test "change_job/1 returns a job changeset" do
      job = job_fixture()
      assert %Ecto.Changeset{} = Jobs.change_job(job)
    end
  end
end
