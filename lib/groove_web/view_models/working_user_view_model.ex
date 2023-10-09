defmodule GrooveWeb.ViewModels.WorkingUserViewModel do
  defstruct user_id: "",
            work_id: "",
            user_name: "",
            work_title: "",
            shift_count: 0,
            work_count: 0,
            total_count: 0

  @type t :: %__MODULE__{
          user_id: Ash.UUID.t(),
          work_id: Ash.UUID.t(),
          user_name: String.t(),
          work_title: String.t(),
          shift_count: pos_integer(),
          work_count: pos_integer(),
          total_count: pos_integer()
        }

  require Ash.Query
  alias Groove.Profiles
  alias Groove.Features
  alias Groove.Work

  @backlog_work_id Application.compile_env!(:groove, :backlog_work_id)

  def get_backlog_work_id do
    @backlog_work_id
  end

  @spec create(%Groove.Work.WorkingUser{}) :: t()
  def create(%Work.WorkingUser{} = working_user) do
    __struct__(
      user_id: working_user.id,
      work_id: working_user.work_id,
      user_name: get_user_name(working_user.id),
      work_title: get_work_title(working_user.work_id),
      shift_count: get_shift_count(working_user),
      work_count: get_work_count(working_user),
      total_count: get_total_count(working_user)
    )
  end

  defp get_shift_count(%Work.WorkingUser{} = working_user) do
    DateTime.diff(DateTime.utc_now(:second), working_user.start_at)
  end

  defp get_work_count(%Work.WorkingUser{} = working_user) do
    work_time =
      Work.WorkShift
      |> Ash.Query.filter(user_id == ^working_user.id and work_id == ^working_user.work_id)
      |> Work.sum!(:duration, actor: nil, authorize?: true)

    work_count = time_to_count(work_time)
    work_count + DateTime.diff(DateTime.utc_now(:second), working_user.start_at)
  end

  defp get_total_count(%Work.WorkingUser{} = working_user) do
    total_time =
      Work.WorkShift
      |> Ash.Query.filter(user_id == ^working_user.id)
      |> Work.sum!(:duration, actor: nil, authorize?: true)

    total_count = time_to_count(total_time)
    total_count + DateTime.diff(DateTime.utc_now(:second), working_user.start_at)
  end

  defp time_to_count(%Time{} = time) do
    Time.diff(time, Time.new!(0, 0, 0), :second)
  end

  defp time_to_count(_) do
    0
  end

  defp get_user_name(user_id) do
    Profiles.get!(Profiles.Profile, user_id, actor: nil, authorize?: true).name
  end

  defp get_work_title(work_id) do
    case work_id do
      @backlog_work_id ->
        "Backlog"

      id ->
        feature =
          Features.Feature
          |> Features.get!(id, actor: nil, authorize?: true)

        if String.length(feature.title) > 22 do
          sliced_title =
            feature.title
            |> String.slice(0..20)

          sliced_title <> "..."
        else
          feature.title
        end
    end
  end
end
