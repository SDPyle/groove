defmodule Groove.Work.WorkingUser do
  @moduledoc """
  A resource for currently working users.
  """
  require Ash.Resource.Change.Builtins

  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    notifiers: [Ash.Notifier.PubSub]

  require Logger
  alias Groove.Work
  alias Groove.Work.WorkShift

  postgres do
    table "working_users"
    repo Groove.Repo
  end

  policies do
    policy action_type(:create) do
      authorize_unless actor_attribute_equals(:confirmed_at, nil)
    end

    policy action_type(:update) do
      authorize_if relates_to_actor_via(:user)
    end

    policy action_type(:read) do
      authorize_unless actor_attribute_equals(:confirmed_at, nil)
    end

    policy action_type(:destroy) do
      authorize_if relates_to_actor_via(:user)
    end
  end

  pub_sub do
    module GrooveWeb.Endpoint
    prefix "working_user"
    broadcast_type :phoenix_broadcast

    publish :start, "started"
    publish :start, ["started", :work_id]
    publish :end, "ended"
    publish :end, ["ended", :work_id]
  end

  code_interface do
    define_for Groove.Work
    define :start, args: [:work_id]
    define :end
  end

  actions do
    defaults [:read]

    create :start do
      accept [:work_id]

      change relate_actor(:user)
    end

    destroy :end do
      change before_transaction(fn changeset ->
               WorkShift
               |> Ash.Changeset.for_create(:create, %{
                 user_id: changeset.data.id,
                 work_id: changeset.data.work_id,
                 start_at: changeset.data.start_at,
                 end_at: DateTime.utc_now(:second)
               })
               |> Work.create!(actor: nil, authorize?: true)

               changeset
             end)
    end
  end

  attributes do
    attribute :id, :uuid do
      primary_key? true
      allow_nil? false
    end

    attribute :work_id, :uuid do
      allow_nil? false
    end

    attribute :start_at, :utc_datetime do
      allow_nil? false
      default &DateTime.utc_now/0
    end
  end

  relationships do
    belongs_to :user, Groove.Accounts.User do
      api Groove.Accounts
      source_attribute :id
      destination_attribute :id
    end
  end
end
