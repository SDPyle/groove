defmodule Groove.ProfilesTest do
  use Groove.DataCase

  require Ash.Query
  require Logger

  import Groove.AccountsFixtures

  alias Groove.Profiles

  @valid_attrs %{
    "name" => "My Name"
  }
  @invalid_attrs %{
    "name" => "Lorem, ipsum dolor sit amet consectetur adipisicing elit. Aliquid."
  }
  @update_attrs %{
    "name" => "Updated Name"
  }

  describe "profile creation" do
    test "should create new profile with valid attributes on confirmed user" do
      user = confirmed_user()

      profile = create_profile(@valid_attrs, user)
      assert profile.name == "My Name"
    end

    test "should not create new profile with invalid attributes on confirmed user" do
      user = confirmed_user()

      assert_raise Ash.Error.Invalid, fn -> create_profile(@invalid_attrs, user) end
    end

    test "should not create a new profile with valid attributes on unconfirmed user" do
      user = unconfirmed_user()

      assert_raise Ash.Error.Forbidden, fn -> create_profile(@valid_attrs, user) end
    end
  end

  describe "profile update" do
    test "should update profile with valid attributes and owner user" do
      user = confirmed_user()
      profile = create_profile(@valid_attrs, user)
      updated_profile = update_profile(profile, @update_attrs, user)

      assert updated_profile.name == "Updated Name"
    end

    test "should not update profile with invalid attributes and owner user" do
      user = confirmed_user()
      profile = create_profile(@valid_attrs, user)
      assert_raise Ash.Error.Invalid, fn -> update_profile(profile, @invalid_attrs, user) end
    end

    test "should not update profile with valid attributes and non-owner user" do
      user = confirmed_user()
      user2 = confirmed_user("test2@test")
      profile = create_profile(@valid_attrs, user)

      assert_raise Ash.Error.Forbidden, fn ->
        update_profile(profile, @update_attrs, user2)
      end
    end
  end

  defp create_profile(attrs, user) do
    Profiles.Profile
    |> Ash.Changeset.for_create(:create, Map.put(attrs, "id", user.id), actor: user)
    |> Profiles.create!()
  end

  defp update_profile(profile, attrs, user) do
    profile
    |> Ash.Changeset.for_update(:update, attrs, actor: user)
    |> Profiles.update!()
  end
end
