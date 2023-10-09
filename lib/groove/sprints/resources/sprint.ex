defmodule Groove.Sprints.Sprint do
  @moduledoc """
  Resource for managing sprints.
  """
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "sprints"
    repo Groove.Repo
  end

  policies do
    policy action_type(:create) do
      authorize_if always()
    end

    policy action_type(:read) do
      authorize_if always()
    end

    policy action_type(:update) do
      authorize_if always()
    end

    policy action_type(:destroy) do
      authorize_if always()
    end
  end

  code_interface do
    define_for Groove.Sprints

    define :get_with_features, action: :with_features, args: [:id]
    define :list, action: :list
    define :start, action: :start, args: [:title, :start_at, :end_at]
    define :add_feature, action: :add_feature, args: [:feature_id]
    define :remove_feature, action: :remove_feature, args: [:feature_id]
  end

  actions do
    defaults [:update, :destroy, :read]

    read :with_features do
      get? true
      argument :id, :uuid, allow_nil?: false

      prepare build(load: [:features])
      filter expr(id == ^arg(:id))
    end

    read :list do
      pagination do
        default_limit 5
        offset? true
        countable :by_default
      end
    end

    create :start do
      primary? true
      accept [:title, :start_at, :end_at]
    end

    update :add_feature do
      argument :feature_id, :uuid do
        allow_nil? false
      end

      change manage_relationship(:feature_id, :features, type: :append)
    end

    update :remove_feature do
      argument :feature_id, :uuid do
        allow_nil? false
      end

      change manage_relationship(:feature_id, :features, type: :remove)
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :title, :string do
      allow_nil? false
    end

    attribute :start_at, :date do
      allow_nil? false
    end

    attribute :end_at, :date do
      allow_nil? false
    end

    create_timestamp :created_at
    create_timestamp :updated_at
  end

  relationships do
    has_many :features, Groove.Features.Feature do
      api Groove.Features
    end
  end
end
