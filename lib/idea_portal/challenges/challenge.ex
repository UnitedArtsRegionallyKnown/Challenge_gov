defmodule IdeaPortal.Challenges.Challenge do
  @moduledoc """
  User schema
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias IdeaPortal.Accounts.User
  alias IdeaPortal.SupportingDocuments.Document
  alias IdeaPortal.Timeline.Event

  @type t :: %__MODULE__{}

  @agencies ["IARPA", "Bureau of the Census", "Agency for International Development", "Bureau of Reclamation", "Department of the Interior", "Department of Energy", "Environmental Protection Agency", "Department of State", "Defense Advanced Research Projects Agency", "National Science Foundation", "United States Patent and Trademark Office", "Department of Health and Human Services", "Department of Homeland Security", "Department of the Interior", "NASA", "Department of Defense", "International Assistance Programs - Department of State", "International Assistance Programs - Agency for International Development", "The White House", "Executive Residence at the White House", "Commission of the Intelligence Capabilities of the…ited States Regarding Weapons of Mass Destruction", "Council of Economic Advisers", "Council on Environmental Quality and Office of Environmental  Quality", "Council on International Economic Policy", "Council on Wage and Price Stability", "Office of Policy Development", "National Security Council and Homeland Security Council", "National Space Council", "National Critical Materials Council", "Armstrong Resolution", "Office of National Service", "Office of Management and Budget", "Office of National Drug Control Policy", "Office of Science and Technology Policy", "Office of the United States Trade Representative", "Office of Telecommunications Policy", "The Points of Light Foundation", "White House Conference for a Drug Free America", "Special Action Office for Drug Abuse Prevention", "Office of Drug Abuse Policy", "Unanticipated Needs", "Expenses of Management Improvement", "Presidential Transition", "National Nuclear Security Administration", "Environmental and Other Defense Activities", "Energy Programs", "Power Marketing Administration", "General Administration", "United States Parole Commission", "Legal Activities and U.S. Marshals", "Radiation Exposure Compensation", "National Security Division", "Federal Bureau of Investigation", "Drug Enforcement Administration", "Bureau of Alcohol, Tobacco, Firearms, and Explosives", "Federal Prison System", "Office of Justice Programs", "Violent Crime Reduction Trust Fund", "Employment and Training Administration", "Employee Benefits Security Administration", "Pension Benefit Guaranty Corporation", "Office of Workers' Compensation Programs", "Wage and Hour Division", "Employment Standards Administration", "Occupational Safety and Health Administration", "Mine Safety and Health Administration", "Bureau of Labor Statistics", "Office of Federal Contract Compliance Programs", "Office of Labor Management Standards", "Office of Elementary and Secondary Education", "Office of Innovation and Improvement", "Office of Safe and Drug-Free Schools", "Office of English Language Acquisition", "Office of Special Education and Rehabilitative Services", "Office of Vocational and Adult Education", "Office of Postsecondary Education", "Office of Federal Student Aid", "Institute of Education Sciences", "Hurricane Education Recovery", "Financial Crimes Enforcement Network", "Financial Management Service", "Federal Financing Bank", "Fiscal Service", "Alcohol and Tobacco Tax and Trade Bureau", "Bureau of Engraving and Printing", "United States Mint", "Bureau of the Public Debt", "Internal Revenue Service", "Comptroller of the Currency", "Office of Thrift Supervision", "Interest on the Public Debt", "Bureau of Land Management", "Bureau of Ocean Energy Management", "Bureau of Safety and Environmental Enforcement", "Office of Surface Mining Reclamation and Enforcement", "Department of the Interior - Bureau of Reclamation", "Central Utah Project", "United States Geological Survey", "Bureau of Mines", "United States Fish and Wildlife Service"]

  schema "challenges" do
    field(:challenge_manager_of_record, :string)
    field(:challenge_manager_email, :string)
    field(:point_of_contact, :string)
    field(:lead_agency_name, :string)
    field(:federal_partner_agency, :string)
    field(:non_federal_partners, :string)

    # field(:champion_name, :string)
    # field(:champion_email, :string)
    #
    # field(:submitter_first_name, :string)
    # field(:submitter_last_name, :string)
    # field(:submitter_email, :string)
    # field(:submitter_phone, :string)

    belongs_to(:user, User)

    has_many(:events, Event)
    has_many(:supporting_documents, Document)

    timestamps()
  end

  @doc """
  List of all focus areas
  """
  def agencies(), do: @agencies

  def create_changeset(struct, params, user) do
    struct
    |> cast(params, [
      :challenge_manager_of_record,
      :challenge_manager_email,
      :point_of_contact,
      :lead_agency_name,
      :federal_partner_agency,
      :non_federal_partners
    ])
    # need to put_change anything?
    # |> put_change(:submitter_first_name, user.first_name)
    |> validate_required([
      :challenge_manager_of_record,
      :challenge_manager_email,
      :point_of_contact,
      :lead_agency_name
    ])
    |> validate_inclusion(:lead_agency_name, @agencies)
  end

  def update_changeset(struct, params) do
    struct
    |> cast(params, [
      :challenge_manager_of_record,
      :challenge_manager_email,
      :point_of_contact,
      :lead_agency_name,
      :federal_partner_agency,
      :non_federal_partners
    ])
    |> validate_required([
      :challenge_manager_of_record,
      :challenge_manager_email,
      :point_of_contact,
      :lead_agency_name
    ])
    |> validate_inclusion(:lead_agency_name, @agencies)
  end

# to allow change to admin info?
  def admin_changeset(struct, params, user) do
    struct
    |> create_changeset(params, user)
  end

  def publish_changeset(struct) do
    struct
    |> change()
    |> put_change(:status, "created")
    |> put_change(:published_on, Date.utc_today())
  end
end
