defmodule Groove.Work.WorkShift do
  @moduledoc """
  Resource for tracking work shifts.
  """

  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  # authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "work_shifts"
    repo Groove.Repo

    custom_indexes do
      index [:user_id], unique: false
      index [:work_id], unique: false
    end
  end

  # policies do
  #   policy action_type(:create) do
  #     authorize_unless actor_attribute_equals(:confirmed_at, nil)
  #   end

  #   policy action_type(:update) do
  #     authorize_if relates_to_actor_via(:user)
  #   end

  #   policy action_type(:read) do
  #     authorize_unless actor_attribute_equals(:confirmed_at, nil)
  #   end
  # end

  # code_interface do
  #   define_for Groove.Work
  #   define :start, args: [:work_id, :start_at]
  #   define :end, args: [:end_at]
  # end

  actions do
    defaults [:create, :read, :update, :destroy]

    # create :start do
    #   accept [:work_id, :start_at]

    #   change relate_actor(:user)
    #   # change Groove.Work.Changes.SetStartTime
    # end

    # update :end do
    #   accept [:end_at]
    #   # change Groove.Work.Changes.SetEndTime
    # end
  end

  calculations do
    calculate :duration, :time, expr(end_at - start_at)
  end

  attributes do
    uuid_primary_key :id

    attribute :user_id, :uuid do
      allow_nil? false
    end

    attribute :work_id, :uuid do
      allow_nil? false
    end

    attribute :start_at, :utc_datetime do
      allow_nil? false
    end

    attribute :end_at, :utc_datetime do
      allow_nil? true
    end
  end
end
