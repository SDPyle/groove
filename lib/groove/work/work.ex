defmodule Groove.Work do
  use Ash.Api

  resources do
    resource Groove.Work.WorkingUser
    resource Groove.Work.WorkShift
  end

  authorization do
    require_actor? true
    authorize :by_default
  end
end
