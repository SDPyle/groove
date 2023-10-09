defmodule Groove.FeaturesTest do
  require Logger
  use Groove.DataCase

  import Groove.{AccountsFixtures, SprintsFixtures}

  alias Groove.Features

  describe "feature creation" do
    @valid_attrs %{
      "title" => "Nice Title",
      "description" => "Nice Description"
    }

    @update_attrs %{
      "title" => "Updated Title",
      "description" => "Updated Description",
      "status" => "ready"
    }

    @invalid_attrs %{"status" => "bad_status"}
    test "should be created with valid attributes" do
      user = confirmed_user()
      feature = create_feature(@valid_attrs, user)

      assert feature.title == @valid_attrs["title"]
      assert feature.description == @valid_attrs["description"]
      assert feature.status == :new
    end

    test "should not be created with invalid attributes" do
      user = confirmed_user()
      assert_raise Ash.Error.Invalid, fn -> create_feature(@invalid_attrs, user) end
    end
  end

  describe "update feature" do
    test "should be updated with valid attributes" do
      user = confirmed_user()

      feature =
        create_feature(@valid_attrs, user)
        |> update_feature(@update_attrs, user)

      assert feature.title == @update_attrs["title"]
      assert feature.description == @update_attrs["description"]
      assert feature.status == :ready
    end

    test "should not be updated with invalid attributes" do
      user = confirmed_user()

      feature =
        create_feature(@valid_attrs, user)

      assert_raise Ash.Error.Invalid, fn -> update_feature(feature, @invalid_attrs, user) end
    end

    # test "assign sprint should work" do
    #   user = confirmed_user()
    #   sprint = create_sprint(user)

    #   feature =
    #     create_feature(@valid_attrs, user)
    #     |> Features.Feature.assign_sprint!(sprint.id, actor: user)

    #   assert feature.id != nil
    # end

    # test "remove sprint should work" do
    #   user = confirmed_user()
    #   sprint = create_sprint(user)

    #   feature =
    #     create_feature(@valid_attrs, user)
    #     |> Features.Feature.assign_sprint!(sprint.id, actor: user)

    #   assert feature.sprint_id != nil

    #   feature2 =
    #     feature
    #     |> Ash.Changeset.for_update(:update, %{"sprint_id" => nil}, actor: user)
    #     |> Features.update!()

    #   assert feature2.sprint_id == nil
    # end
  end

  describe "read features" do
    test "should read by id" do
      user = confirmed_user()
      feature = create_feature(@valid_attrs, user)
      got_feature = get_feature_by_id(feature.id, user)
      assert got_feature.title == feature.title
    end

    test "should list recent" do
      user = confirmed_user()
      create_feature(@valid_attrs, user)
      create_feature(@valid_attrs, user)
      create_feature(@valid_attrs, user)

      features = Features.Feature.list_recent!(actor: user)
      assert Enum.count(features) == 3
    end

    test "should list by status" do
      user = confirmed_user()
      create_feature(@valid_attrs, user)
      create_feature(@valid_attrs, user)
      create_feature(@valid_attrs, user)

      features = Features.Feature.by_status!(:new, actor: user)
      assert Enum.count(features) == 3

      features = Features.Feature.by_status!(:ready, actor: user)
      assert Enum.count(features) == 0
    end
  end

  defp create_feature(attrs, user) do
    Features.Feature
    |> Ash.Changeset.for_create(:create, attrs, actor: user)
    |> Features.create!()
  end

  defp update_feature(feature, attrs, user) do
    feature
    |> Ash.Changeset.for_update(:update, attrs, actor: user)
    |> Features.update!()
  end

  defp get_feature_by_id(id, user) do
    Features.Feature
    |> Features.get!(id, actor: user)
  end
end
