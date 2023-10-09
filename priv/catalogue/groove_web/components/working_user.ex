defmodule GrooveWeb.Components.WorkingUserExamples do
  @moduledoc """
  Examples using the WorkingUser components
  """

  use Surface.Catalogue.Examples,
    subject: GrooveWeb.Components.WorkingUser

  alias GrooveWeb.Components.WorkingUser

  @example [
    title: "basic",
    height: "250px",
  ]

  @doc "An basic example."
  def new(assigns) do
    ~F"""
    <WorkingUser name="Person Name" work_title="Work Title" shift_count={3001} work_count={2201} total_count={3243}/>
    """
  end

end
