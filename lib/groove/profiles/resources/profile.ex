defmodule Groove.Profiles.Profile do
  @moduledoc """
  Profile is created using same id as credentials.
  """

  alias Groove.Accounts.User

  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  policies do
    policy action_type(:create) do
      authorize_unless actor_attribute_equals(:confirmed_at, nil)
    end

    policy action_type(:update) do
      authorize_if relates_to_actor_via(:owner)
    end

    policy action_type(:read) do
      authorize_unless actor_attribute_equals(:confirmed_at, nil)
    end
  end

  actions do
    defaults [:create, :read, :update]
  end

  attributes do
    attribute :id, :uuid do
      primary_key? true
      allow_nil? false
    end

    attribute :name, :string do
      allow_nil? false
      constraints max_length: 64
    end
  end

  postgres do
    table "profiles"
    repo Groove.Repo
  end

  relationships do
    belongs_to :owner, User do
      source_attribute :id
      destination_attribute :id
    end
  end
end
