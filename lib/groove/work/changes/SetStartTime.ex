defmodule Groove.Work.Changes.SetStartTime do
  use Ash.Resource.Change

  alias Ash.Changeset

  @impl true
  def change(changeset, _options, _context) do
    Changeset.before_action(changeset, &set_start_time/1)
  end

  defp set_start_time(changeset) do
    Changeset.change_attribute(changeset, :start_at, DateTime.utc_now())
  end
end
