defmodule Groove.AccountsFixtures do
  @moduledoc """
  Helpers for creating account entities
  """

  alias AshAuthentication.{Info, Strategy}
  alias Groove.Accounts.User
  alias Groove.Profiles

  @valid_attrs %{
    "email" => "test@test",
    "password" => "thisIsAGoodPassword123",
    "password_confirmation" => "thisIsAGoodPassword123"
  }

  def unconfirmed_user() do
    {:ok, user} = register(@valid_attrs)
    user
  end

  def confirmed_user(email \\ "test@test") do
    {:ok, user} = register(%{@valid_attrs | "email" => email})
    {:ok, confirmed_user} = confirm(user)
    confirmed_user
  end

  def profiled_user(email \\ "test@test", name \\ "Test Name") do
    user = confirmed_user(email)
    create_profile(user, name)
    user
  end

  defp register(attrs) do
    strategy = Info.strategy!(User, :password)
    Strategy.action(strategy, :register, attrs)
  end

  defp confirm(user) do
    confirmStrategy = Info.strategy!(User, :confirm)

    Strategy.action(confirmStrategy, :confirm, %{
      "confirm" => user.__metadata__.confirmation_token
    })
  end

  defp create_profile(user, name) do
    Profiles.Profile
    |> Ash.Changeset.for_create(:create, %{id: user.id, name: name}, actor: user)
    |> Profiles.create!()
  end
end
