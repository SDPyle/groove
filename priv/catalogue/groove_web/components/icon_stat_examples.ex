defmodule GrooveWeb.Components.IconStatExamples do
  @moduledoc """
  Example using the IconStat
  """

  use Surface.Catalogue.Examples,
    subject: GrooveWeb.Components.IconStat

  alias GrooveWeb.Components.IconStat

  @example [
    title: "simple",
    height: "150px",
  ]

  @doc "An example of a non-actve link."
  def simple(assigns) do
    ~F"""
    <IconStat header="Users" stat="40012" icon="users"/>
    """
  end

end
