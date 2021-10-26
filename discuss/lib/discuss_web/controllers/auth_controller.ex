defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  alias Ueberauth.Strategy.Helpers
  alias UeberauthExample.UserFromAuth
  alias Discuss.Repo
  alias Discuss.User
  plug Ueberauth


  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")

  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    IO.inspect conn
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}
    changeset = User.changeset(%User{}, user_params)

    singin(conn, changeset)
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: Routes.topic_path(conn, :index))

  end

  defp singin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> put_session(:current_user, user)
        |> configure_session(renew: true)
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: Routes.topic_path(conn, :index))

      end
  end

  defp insert_or_update_user(changeset) do
    IO.inspect changeset
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end

  #def delete(conn, _params) do
  #  conn
  #  |> put_flash(:info, "You have been logged out!")
  #  |> clear_session()
  #  |> redirect(to: "/")
  #end
end
