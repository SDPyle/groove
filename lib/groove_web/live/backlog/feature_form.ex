defmodule GrooveWeb.Backlog.FeatureForm do
  @moduledoc """
  A form for creating or updating a feature.
  """
  use Surface.LiveComponent

  alias Surface.Components.Form

  @doc "The form struct."
  prop form, :struct, required: true

  @doc "The submit event."
  prop submit, :event, required: true

  @doc "The change event."
  prop change, :event, required: true

  data status_options, :map,
    default: [
      New: :new,
      Ready: :ready,
      "In Progress": :in_progress,
      "Needs Review": :needs_review,
      Completed: :completed,
      Archived: :archived
    ]

  def render(assigns) do
    ~F"""
    <Form for={@form} opts={autocomplete: "off"} submit={@submit} change={@change}>
      <Form.Field name={:title}>
        <Form.Label />
        <div class="control">
          <Form.TextInput class="input text mb-4 w-full" />
          <Form.ErrorTag />
        </div>
      </Form.Field>
      <Form.Field name={:description}>
        <Form.Label />
        <div class="control">
          <Form.TextArea rows="7" class="input text mb-4 w-full" />
          <Form.ErrorTag />
        </div>
      </Form.Field>

      <Form.Field name={:points}>
        <Form.Label />
        <div class="control">
          <Form.NumberInput class="input text mb-4" />
          <Form.ErrorTag />
        </div>
      </Form.Field>

      <Form.Field name={:status}>
        <Form.Label />
        <div class="control">
          <Form.Select options={@status_options} class="input text mb-4 w-48" />
          <Form.ErrorTag />
        </div>
      </Form.Field>

      <Form.Submit label="Submit" class="button submit" />
    </Form>
    """
  end
end
