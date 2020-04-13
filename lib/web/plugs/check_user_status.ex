defmodule Web.Plugs.CheckUserStatus do
  @moduledoc """
  Verify a user is active
  """

  import Plug.Conn
  import Phoenix.Controller

  alias Web.Router.Helpers, as: Routes

  def init(default), do: default

  def call(conn, _opts) do
    with {:ok, user} <- Map.fetch(conn.assigns, :current_user) do
      case user.status do
        # "pending" ->
        #   conn
        #   |> clear_flash()
        #   |> put_flash(:error, "Your account is pending activation")
        #   |> clear_session()
        #   |> redirect(to: Routes.session_path(conn, :new))
        #   |> halt()

        "suspended" ->
          conn
          |> clear_flash()
          |> put_flash(:error, "Your account has been suspended")
          |> clear_session()
          |> redirect(to: Routes.session_path(conn, :new))
          |> halt()

        "revoked" ->
          conn
          |> clear_flash()
          |> put_flash(:error, "Your account has been revoked")
          |> clear_session()
          |> redirect(to: Routes.session_path(conn, :new))
          |> halt()

        "deactivated" ->
          conn
          |> clear_flash()
          |> put_flash(:error, "Your account has been deactivated")
          |> clear_session()
          |> redirect(to: Routes.session_path(conn, :new))
          |> halt()

        "decertified" ->
          conn
          |> clear_flash()
          |> put_flash(:error, "Your account has been decertified")
          |> clear_session()
          |> redirect(to: Routes.session_path(conn, :new))
          |> halt()

        _ ->
          conn
      end
    else
      _ -> conn
    end
  end
end
