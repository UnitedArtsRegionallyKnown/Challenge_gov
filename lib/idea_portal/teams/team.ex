defmodule IdeaPortal.Teams.Team do
  @moduledoc """
  Team schema
  """

  use Ecto.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{}

  alias IdeaPortal.Teams.Member

  schema "teams" do
    field(:name, :string)
    field(:description, :string)
    field(:deleted_at, :utc_datetime)

    has_many(:members, Member)

    timestamps()
  end

  def create_changeset(struct, params) do
    struct
    |> cast(params, [:name, :description])
    |> validate_required([:name])
  end

  def update_changeset(struct, params) do
    struct
    |> cast(params, [:name, :description])
    |> validate_required([:name])
  end
end
