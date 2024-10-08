defmodule AtsWeb.ProfessionController do
  use AtsWeb, :controller

  alias Ats.Professions
  alias Ats.Professions.Profession

  def index(conn, _params) do
    professions = Professions.list_professions()
    render(conn, :index, professions: professions)
  end

  def new(conn, _params) do
    changeset = Professions.change_profession(%Profession{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"profession" => profession_params}) do
    case Professions.create_profession(profession_params) do
      {:ok, profession} ->
        conn
        |> put_flash(:info, "Profession created successfully.")
        |> redirect(to: ~p"/professions/#{profession}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    profession = Professions.get_profession!(id)
    render(conn, :show, profession: profession)
  end

  def edit(conn, %{"id" => id}) do
    profession = Professions.get_profession!(id)
    changeset = Professions.change_profession(profession)
    render(conn, :edit, profession: profession, changeset: changeset)
  end

  def update(conn, %{"id" => id, "profession" => profession_params}) do
    profession = Professions.get_profession!(id)

    case Professions.update_profession(profession, profession_params) do
      {:ok, profession} ->
        conn
        |> put_flash(:info, "Profession updated successfully.")
        |> redirect(to: ~p"/professions/#{profession}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, profession: profession, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    profession = Professions.get_profession!(id)
    {:ok, _profession} = Professions.delete_profession(profession)

    conn
    |> put_flash(:info, "Profession deleted successfully.")
    |> redirect(to: ~p"/professions")
  end
end
