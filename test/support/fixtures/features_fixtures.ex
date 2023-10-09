defmodule Groove.FeaturesFixtures do
  @moduledoc """
  Helper functions to build features.
  """
  @valid_attrs %{
    "title" => "Nice Title",
    "description" => "Nice Description"
  }

  alias Groove.Features

  def feature_fixture(user) do
    Features.Feature
    |> Ash.Changeset.for_create(:create, @valid_attrs, actor: user)
    |> Features.create!()
  end
end
