defmodule Groove.WorkingUsersTest do
  require Logger
  # use Groove.DataCase
  use GrooveWeb.ChannelCase

  import Groove.AccountsFixtures

  alias Groove.Work

  test "start working user" do
    user = confirmed_user()
    work_id = Ash.UUID.generate()

    working_user = Work.WorkingUser.start!(work_id, actor: user)

    assert working_user.id == user.id
    assert working_user.work_id == work_id
    assert working_user.start_at == DateTime.utc_now(:second)
  end

  test "cannot start two working users with same user" do
    user = confirmed_user()
    work_id_1 = Ash.UUID.generate()
    work_id_2 = Ash.UUID.generate()

    working_user_1 = Work.WorkingUser.start!(work_id_1, actor: user)

    assert_raise Ash.Error.Invalid, fn ->
      Work.WorkingUser.start!(work_id_2, actor: user)
    end
  end

  test "end working user creates a work shift" do
    user = confirmed_user()
    work_id = Ash.UUID.generate()

    # assert :ok ==
    #          Work.WorkingUser.start!(work_id, actor: user)
    #          |> Work.destroy!(actor: user)

    working_user =
      Work.WorkingUser.start!(work_id, actor: user)

    assert :ok == Work.WorkingUser.end!(working_user, actor: user)

    assert_raise Ash.Error.Invalid, fn ->
      Work.WorkingUser
      |> Work.get!(user.id, actor: user)
    end

    work_shifts =
      Work.WorkShift
      |> Work.read!(actor: user)

    assert Enum.count(work_shifts) == 1

    work_shift = Enum.at(work_shifts, 0)
    assert work_shift.user_id == user.id
    assert work_shift.work_id == work_id
    assert work_shift.start_at == DateTime.utc_now(:second)
    assert work_shift.end_at == DateTime.utc_now(:second)
  end
end
