defmodule GrooveWeb.Components.ToggleWorkingExamples do
  @moduledoc """
  Examples using the ToggleWorking buttons
  """

  use Surface.Catalogue.Examples,
    subject: GrooveWeb.Components.ToggleWorking

  alias GrooveWeb.Components.ToggleWorking

  @example [
    title: "is working here",
    height: "150px",
  ]

  @doc "An example for when the user is working here."
  def is_working_here(assigns) do
    ~F"""
    <ToggleWorking is_working_here={true} click=""/>
    """
  end

  @example [
    title: "is not working here",
    height: "150px",
  ]

  @doc "An example for when the user is not working here."
  def is_not_working_here(assigns) do
    ~F"""
    <ToggleWorking is_working_here={false} click=""/>
    """
  end
end
