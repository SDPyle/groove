defmodule GrooveWeb.Components.StatusPillExamples do
  @moduledoc """
  Example using the StatusPill
  """

  use Surface.Catalogue.Examples,
    subject: GrooveWeb.Components.StatusPill

  alias GrooveWeb.Components.StatusPill

  @example [
    title: "new",
    height: "50px",
  ]

  @doc "An example with a new status."
  def new(assigns) do
    ~F"""
    <StatusPill status={:new}/>
    """
  end

@example [
    title: "ready",
    height: "50px",
  ]

  @doc "An example with a ready status."
  def ready(assigns) do
    ~F"""
    <StatusPill status={:ready}/>
    """
  end
@example [
    title: "in progress",
    height: "50px",
  ]

  @doc "An example with an in_progress status."
  def in_progress(assigns) do
    ~F"""
    <StatusPill status={:in_progress}/>
    """
  end
@example [
    title: "needs review",
    height: "50px",
  ]

  @doc "An example with a needs_review status."
  def needs_review(assigns) do
    ~F"""
    <StatusPill status={:needs_review}/>
    """
  end

  @example [
    title: "completed",
    height: "50px",
  ]

  @doc "An example with a completed status."
  def completed(assigns) do
    ~F"""
    <StatusPill status={:completed}/>
    """
  end

  @example [
    title: "archived",
    height: "50px",
  ]

  @doc "An example with a completed status."
  def archived(assigns) do
    ~F"""
    <StatusPill status={:archived}/>
    """
  end

end
