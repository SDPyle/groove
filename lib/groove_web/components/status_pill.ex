defmodule GrooveWeb.Components.StatusPill do
  @moduledoc """
  A component for displaying the status of a user story
  """
  use Surface.Component

  @doc "The type of stat being displayed"
  prop status, :atom,
    values: [:new, :ready, :in_progress, :needs_review, :completed, :archived],
    default: :new

  def render(assigns) do
    ~F"""
    <span class={
      "bg-gradient-to-tl px-2.5 text-xs rounded-1.8 py-1.4 inline-block whitespace-nowrap text-center align-baseline font-bold uppercase leading-none",
      "text-white from-slate-600 to-slate-400": @status == :new,
      "text-white from-amber-600 to-amber-400": @status == :ready,
      "text-white from-green-600 to-lime-400": @status == :in_progress,
      "text-white from-fuchsia-600 to-violet-400": @status == :needs_review,
      "text-white from-teal-600 to-teal-400": @status == :completed,
      "from-gray-600 to-gray-400": @status == :archived
    }>
      {#case @status}
        {#match :new}
          New
        {#match :ready}
          Ready
        {#match :in_progress}
          In Progress
        {#match :needs_review}
          Needs Review
        {#match :completed}
          Completed
        {#match :archived}
          Archived
      {/case}
    </span>
    """
  end
end
