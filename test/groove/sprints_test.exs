defmodule Groove.SprintsTest do
  require Logger
  use Groove.DataCase

  import Groove.AccountsFixtures
  import Groove.FeaturesFixtures

  alias Groove.{Sprints, Features}

  @valid_attrs %{
    "title" => "Valid title",
    "start_at" => Date.utc_today(),
    "end_at" => Date.add(Date.utc_today(), 14)
  }
  @invalid_attrs %{
    "title" => "",
    "start_at" => "",
    "end_at" => ""
  }
  @update_attrs %{
    "title" => "Updated title",
    "start_at" => Date.add(Date.utc_today(), 7),
    "end_at" => Date.add(Date.utc_today(), 21)
  }

  describe "sprint creation" do
    test "should work with valid attributes" do
      user = confirmed_user()

      sprint =
        create_sprint(user)

      assert sprint.title == @valid_attrs["title"]
      assert sprint.start_at == @valid_attrs["start_at"]
      assert sprint.end_at == @valid_attrs["end_at"]
    end

    test "should not work with invalid attributes" do
      user = confirmed_user()

      assert_raise Ash.Error.Invalid, fn ->
        Sprints.Sprint.start!(
          @invalid_attrs["title"],
          @invalid_attrs["start_at"],
          @invalid_attrs["end_at"],
          actor: user
        )
      end
    end
  end

  describe "sprint update" do
    test "should work with valid attributes" do
      user = confirmed_user()

      sprint =
        create_sprint(user)
        |> update_sprint(@update_attrs, user)

      assert sprint.title == @update_attrs["title"]
      assert sprint.start_at == @update_attrs["start_at"]
      assert sprint.end_at == @update_attrs["end_at"]
    end

    test "should not work with invalid attributes" do
      user = confirmed_user()

      assert_raise Ash.Error.Invalid, fn ->
        Sprints.Sprint.start!(
          @valid_attrs["title"],
          @valid_attrs["start_at"],
          @valid_attrs["end_at"],
          actor: user
        )
        |> update_sprint(@invalid_attrs, user)
      end
    end

    test "add feature should set feature's relationship to sprint" do
      user = confirmed_user()
      feature = feature_fixture(user)

      sprint =
        create_sprint(user)
        |> Sprints.Sprint.add_feature!(feature.id, actor: user)
        |> Sprints.Sprint.add_feature!(feature.id, actor: user)

      assert Enum.count(sprint.features) == 1

      feature =
        Features.Feature
        |> Features.get!(feature.id, actor: user)

      assert feature.sprint_id != nil
    end

    test "remove feature should remove feature's relationship to sprint" do
      user = confirmed_user()
      feature = feature_fixture(user)

      sprint =
        create_sprint(user)
        |> Sprints.Sprint.add_feature!(feature.id, actor: user)

      assert Enum.count(sprint.features) == 1

      feature =
        Features.Feature
        |> Features.get!(feature.id, actor: user)

      sprint
      |> Sprints.Sprint.remove_feature!(feature.id, actor: user)

      sprint =
        Sprints.Sprint
        |> Ash.Query.for_read(:read, %{id: sprint.id}, actor: user)
        |> Ash.Query.load(:features)
        |> Sprints.read_one!()

      assert Enum.count(sprint.features) == 0

      feature =
        Features.Feature
        |> Features.get!(feature.id, actor: user)

      assert feature.sprint_id == nil
    end
  end

  describe "sprint read" do
    test "list should give a default of 5 sprints" do
      user = confirmed_user()
      create_sprint(user)
      create_sprint(user)
      create_sprint(user)
      create_sprint(user)
      create_sprint(user)
      create_sprint(user)

      sprints = Sprints.Sprint.list!(actor: user)

      assert Enum.count(sprints.results) == 5
    end
  end

  defp create_sprint(user) do
    Sprints.Sprint.start!(
      @valid_attrs["title"],
      @valid_attrs["start_at"],
      @valid_attrs["end_at"],
      actor: user
    )
  end

  defp update_sprint(sprint, attrs, user) do
    sprint
    |> Ash.Changeset.for_update(:update, attrs, actor: user)
    |> Sprints.update!()
  end
end
