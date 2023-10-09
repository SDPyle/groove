defmodule Groove.Accounts do
  use Ash.Api

  authorization do
    authorize :by_default
  end

  resources do
    resource Groove.Accounts.User
    resource Groove.Accounts.Token
  end
end
