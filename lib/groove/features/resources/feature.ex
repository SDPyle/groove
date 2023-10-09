defmodule Groove.Features.Feature do
  @moduledoc """
  Feature work resource
  """

  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    notifiers: [Ash.Notifier.PubSub]

  @possible_status [:new, :ready, :in_progress, :needs_review, :completed, :archived]

  postgres do
    table "features"
    repo Groove.Repo

    custom_indexes do
      index [:status], unique: false
    end
  end

  policies do
    policy action_type(:create) do
      authorize_unless actor_attribute_equals(:confirmed_at, nil)
    end

    policy action_type(:update) do
      authorize_unless actor_attribute_equals(:confirmed_at, nil)
    end

    policy action_type(:read) do
      authorize_unless actor_attribute_equals(:confirmed_at, nil)
    end

    policy action_type(:destroy) do
      authorize_unless actor_attribute_equals(:confirmed_at, nil)
    end
  end

  pub_sub do
    module GrooveWeb.Endpoint
    prefix "feature"
    broadcast_type :phoenix_broadcast

    publish :create, ["created"]
    publish :update, ["updated"]
    publish :destroy, ["destroyed"]
  end

  actions do
    defaults [:create, :read, :update, :destroy]

    read :list_recent do
      prepare build(sort: [updated_at: :desc])
    end

    read :by_status do
      argument :status, :atom do
        constraints one_of: @possible_status
      end

      prepare build(sort: [updated_at: :desc])
      filter expr(status == ^arg(:status))
    end

    read :unarchived do
      prepare build(sort: [updated_at: :desc])
      filter expr(status != :archived)
    end
  end

  code_interface do
    define_for Groove.Features
    define :by_status, args: [:status]
    define :list_recent
    define :unarchived
  end

  attributes do
    uuid_primary_key :id

    attribute :title, :string do
      allow_nil? false
      constraints max_length: 64
    end

    attribute :description, :string

    attribute :points, :integer do
      default 0
    end

    attribute :status, :atom do
      constraints one_of: @possible_status
      default :new
    end

    create_timestamp(:created_at)
    create_timestamp(:updated_at)
  end

  relationships do
    belongs_to :sprint, Groove.Sprints.Sprint do
      api Groove.Sprints
      allow_nil? true
    end
  end
end
