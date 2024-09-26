# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Ats.Repo.insert!(%Ats.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Ats.Repo
alias Ats.Professions.Profession
alias Ats.Jobs.Job
alias Ats.Candidates.Candidate
alias Ats.Applicants.Applicant

Repo.insert!(%Profession{
  id: 1,
  name: "Développement Backend",
  category_name: "Tech"
})

Repo.insert!(%Profession{
  id: 2,
  name: "Développement Frontend",
  category_name: "Tech"
})

Repo.insert!(%Profession{
  id: 3,
  name: "Développement Fullstack",
  category_name: "Tech"
})

Repo.insert!(%Profession{
  id: 4,
  name: "QA",
  category_name: "Tech"
})

Repo.insert!(%Job{
  title: "BackEnd Engineer",
  contract_type: :FULL_TIME,
  description:
    "As a BackEnd Software Engineer, you will join one of our Feature Squads, consisting of several engineers, a product manager, quality and data engineers and a designer.",
  office: "Paris",
  status: :published,
  title: "Dev Backend",
  work_mode: :onsite,
  profession_id: 1
})

Repo.insert!(%Job{
  title: "Senior Frontend Engineer React JS / Ingénieur(e) Senior Frontend React JS",
  contract_type: :FULL_TIME,
  description:
    "We are looking for a Senior Frontend developer to shape our recruitment solutions and help us to build the future of work by joining our tech team of about 50 people. You will join one of our Feature Squads, aligned with business/product goals, consisting of several developers, a product manager, quality and data engineers and a designer.",
  office: "Paris",
  status: :published,
  work_mode: :onsite,
  profession_id: 2
})

Repo.insert!(%Job{
  title: "Senior QA Engineer / Ingénieur(e) QA Senior",
  contract_type: :FULL_TIME,
  description:
    "Are you a bug-hunter with a passion for quality and a knack for finding those pesky glitches that others miss? Look no further, because we have the perfect opportunity for you!",
  office: "Nantes",
  status: :draft,
  work_mode: :hybrid,
  profession_id: 4
})

Repo.insert!(%Candidate{
  id: 1,
  email: "john.doe@gmail.com",
  full_name: "John Doe",
  last_known_job: "Senior dev backend @acme",
  phone: "+33 6 66 66 66 66"
})

Repo.insert!(%Candidate{
  id: 2,
  email: "grace.hopper@whatever.com",
  full_name: "Grace Hopper",
  last_known_job: "Senior mathematician @EMCC",
  phone: "+33 7 77 77 77 77"
})

Repo.insert!(%Applicant{
  application_date: ~D[2023-06-03],
  salary_expectation: 100_000,
  status: "new",
  candidate_id: 1,
  job_id: 1
})

Repo.insert!(%Applicant{
  application_date: ~D[2023-06-03],
  salary_expectation: 120_000,
  status: "new",
  candidate_id: 2,
  job_id: 1
})
