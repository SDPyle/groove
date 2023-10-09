defmodule Groove.WorkFixtures do
  @moduledoc """
  Helpers to create work resources.
  """

  alias Groove.Work

  def create_work_shift(user, work_id, start_at, end_at) do
    attrs = %{
      "user_id" => user.id,
      "work_id" => work_id,
      "start_at" => start_at,
      "end_at" => end_at
    }

    Work.WorkShift
    |> Ash.Changeset.for_create(:create, attrs, actor: user)
    |> Work.create!()
    |> Work.load!(:duration, actor: user)
  end
end
