defmodule Groove.Sprints do
  use Ash.Api

  resources do
    resource Groove.Sprints.Sprint
  end

  authorization do
    require_actor? true
    authorize :by_default
  end
end
