defmodule Groove.Profiles do
  use Ash.Api

  resources do
    resource Groove.Profiles.Profile
  end

  authorization do
    require_actor? true
    authorize :by_default
  end
end
