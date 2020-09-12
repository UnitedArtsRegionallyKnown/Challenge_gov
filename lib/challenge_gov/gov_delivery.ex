defmodule ChallengeGov.GovDelivery do
  @moduledoc """
  Integration with GovDelivery
  """

  alias ChallengeGov.Challenges
  alias ChallengeGov.Accounts

  @type challenge() :: Challenges.Challenge.t()
  @type user() :: Accounts.User.t()

  @callback remove_topic(challenge()) :: tuple()
  @callback add_topic(challenge()) :: tuple()
  @callback subscribe_user_general(user()) :: tuple()
  @callback subscribe_user_challenge(user(), challenge()) :: tuple()

  @module Application.get_env(:challenge_gov, :gov_delivery)[:module]

  @doc """
  Get the username for GovDelivery
  """
  def username() do
    ChallengeGov.config(Application.get_env(:challenge_gov, __MODULE__)[:username])
  end

  @doc """
  Get the password for GovDelivery
  """
  def password() do
    ChallengeGov.config(Application.get_env(:challenge_gov, __MODULE__)[:password])
  end

  @doc """
  Get the endpoint for GovDelivery
  """
  def endpoint() do
    ChallengeGov.config(Application.get_env(:challenge_gov, __MODULE__)[:url])
  end

  @doc """
  Get the account code for GovDelivery
  """
  def account_code() do
    ChallengeGov.config(Application.get_env(:challenge_gov, __MODULE__)[:account_code])
  end

  @doc """
  Get the category code for topics for active challenges for GovDelivery
  """
  def challenge_topic_category_code() do
    ChallengeGov.config(Application.get_env(:challenge_gov, __MODULE__)[:challenge_category_code])
  end

  @doc """
  Get the prefix for all topic codes for challenges
  """
  def challenge_topic_prefix_code() do
    ChallengeGov.config(
      Application.get_env(:challenge_gov, __MODULE__)[:challenge_topic_prefix_code]
    )
  end

  @doc """
  Get the platform news topic for GovDelivery
  """
  def news_topic_code() do
    ChallengeGov.config(Application.get_env(:challenge_gov, __MODULE__)[:news_topic_code])
  end

  def create_topic_endpoint() do
    "#{endpoint()}/api/account/#{account_code()}/topics.xml"
  end

  def set_topic_categories_endpoint(code) do
    "#{endpoint()}/api/account/#{account_code()}/topics/#{code}/categories.xml"
  end

  def remove_topic_endpoint(code) do
    "#{endpoint()}/api/account/#{account_code()}/topics/#{code}.xml"
  end

  def subscribe_endpoint() do
    "#{endpoint()}/api/account/#{account_code()}/subscriptions.xml"
  end

  @doc """
  Add challenge as a topic
  """
  def add_topic(challenge) do
    @module.add_topic(challenge)
  end

  @doc """
  Add challenge as a topic
  """
  def remove_topic(challenge) do
    @module.remove_topic(challenge)
  end

  @doc """
  Subscribe User
  """
  def subscribe_user_general(user) do
    @module.subscribe_user_general(user)
  end

  @doc """
  Subscribe User
  """
  def subscribe_user_challenge(user, challenge) do
    @module.subscribe_user_challenge(user, challenge)
  end

  @doc """
  Ensure all topics are correct in GovDelivery
  """
  def check_topics do
    Challenges.all_for_govdelivery()
    |> Enum.each(fn challenge ->
      add_topic(challenge)
    end)

    Challenges.all_for_removal_from_govdelivery()
    |> Enum.each(fn challenge ->
      remove_topic(challenge)
    end)
  end
end
