defmodule Groove.SprintsFixtures do
  @moduledoc """
  Helpers to create sprints.
  """

  alias Groove.Sprints

  @valid_attrs %{
    "title" => "Valid title",
    "start_at" => Date.utc_today(),
    "end_at" => Date.add(Date.utc_today(), 14)
  }

  def create_sprint(user) do
    Sprints.Sprint.start!(
      @valid_attrs["title"],
      @valid_attrs["start_at"],
      @valid_attrs["end_at"],
      actor: user
    )
  end
end
