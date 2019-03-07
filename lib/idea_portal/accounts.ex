defmodule IdeaPortal.Accounts do
  @moduledoc """
  Context for user accounts
  """

  alias IdeaPortal.Accounts.User
  alias IdeaPortal.Emails
  alias IdeaPortal.Mailer
  alias IdeaPortal.Recaptcha
  alias IdeaPortal.Repo

  @doc """
  Changeset for sign in and registration
  """
  def new() do
    User.create_changeset(%User{}, %{})
  end

  @doc """
  Register an account
  """
  def register(params) do
    recaptcha_token = Map.get(params, "recaptcha_token")

    case Recaptcha.valid_token?(recaptcha_token) do
      true ->
        %User{}
        |> User.create_changeset(params)
        |> Repo.insert()
        |> maybe_send_email_verification()

      false ->
        %User{}
        |> User.create_changeset(params)
        |> Ecto.Changeset.add_error(:recaptcha_token, "is invalid")
        |> Ecto.Changeset.apply_action(:insert)
    end
  end

  defp maybe_send_email_verification({:ok, user}) do
    user
    |> Emails.verification_email()
    |> Mailer.deliver_later()

    {:ok, user}
  end

  defp maybe_send_email_verification(result), do: result

  @doc """
  Validate a user's login information
  """
  def validate_login(email, password) do
    Stein.Accounts.validate_login(Repo, User, email, password)
  end

  @doc """
  Find a user by a token
  """
  def get_by_token(token) do
    case Ecto.UUID.cast(token) do
      {:ok, token} ->
        case Repo.get_by(User, token: token) do
          nil ->
            {:error, :not_found}

          user ->
            {:ok, user}
        end

      :error ->
        {:error, :not_found}
    end
  end
end
