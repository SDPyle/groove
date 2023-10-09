defmodule Groove.Work.Changes.SetEndTime do
  use Ash.Resource.Change

  alias Ash.Changeset

  @impl true
  def change(changeset, _options, _context) do
    Changeset.before_action(changeset, &set_end_time/1)
  end

  defp set_end_time(changeset) do
    Changeset.change_attribute(changeset, :end_at, DateTime.utc_now())
  end
end
