defmodule Groove.Work.WorkShift do
  @moduledoc """
  Resource for tracking work shifts.
  """

  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "work_shifts"
    repo Groove.Repo

    custom_indexes do
      index [:user_id], unique: false
      index [:work_id], unique: false
    end
  end

  actions do
    defaults [:create, :read, :update, :destroy]
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
