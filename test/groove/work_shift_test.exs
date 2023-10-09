defmodule Groove.WorkPeriodTest do
  require Ash.Query
  use Groove.DataCase

  import Groove.AccountsFixtures
  import Groove.WorkFixtures

  alias Groove.Work

  @valid_params

  test "create work period" do
    user = confirmed_user()
    work_id = Ash.UUID.generate()

    start_at = DateTime.utc_now(:second)
    end_at = DateTime.add(start_at, 30, :minute)

    work_shift = create_work_shift(user, work_id, start_at, end_at)

    assert work_shift.user_id == user.id
    assert work_shift.work_id == work_id
    assert work_shift.start_at == start_at
    assert work_shift.end_at == end_at
    assert work_shift.duration == Time.new!(0, 30, 0)
  end

  test "sum work duration" do
    user = confirmed_user()
    user2 = confirmed_user("test2@test.com")
    work_id = Ash.UUID.generate()
    work_id2 = Ash.UUID.generate()

    start_at = DateTime.utc_now(:second)
    end_at = DateTime.add(DateTime.utc_now(:second), 30, :minute)

    create_work_shift(user, work_id, start_at, end_at)
    create_work_shift(user, work_id, start_at, end_at)
    create_work_shift(user, work_id, start_at, end_at)
    create_work_shift(user, work_id2, start_at, end_at)
    create_work_shift(user, work_id2, start_at, end_at)
    create_work_shift(user2, work_id, start_at, end_at)
    create_work_shift(user2, work_id, start_at, end_at)

    duration =
      Work.WorkShift
      |> Ash.Query.filter(user_id == ^user.id and work_id == ^work_id)
      |> Work.sum!(:duration, actor: user)

    assert duration == Time.new!(1, 30, 0)

    duration =
      Work.WorkShift
      |> Ash.Query.filter(user_id == ^user.id)
      |> Work.sum!(:duration, actor: user)

    assert duration == Time.new!(2, 30, 0)

    assert Time.diff(duration, Time.new!(0, 0, 0), :second) == 9000
  end
end
