defmodule Groove.Features do
  use Ash.Api

  resources do
    resource Groove.Features.Feature
  end

  authorization do
    require_actor? true
    authorize :by_default
  end
end
