defmodule GrooveWeb.Components.IconLinkExamples do
  @moduledoc """
  Example using the IconLink
  """

  use Surface.Catalogue.Examples,
    subject: GrooveWeb.Components.IconLink

  alias GrooveWeb.Components.IconLink

  @example [
    title: "non-active",
    height: "110px",
  ]

  @doc "An example of a non-actve link."
  def example(assigns) do
    ~F"""
    <IconLink icon="academic-cap" to="#">
      Test123
    </IconLink>
    """
  end

  @example [
    title: "solid",
    height: "110px",
  ]

  @doc "An example with a solid icon."
  def solid_example(assigns) do
    ~F"""
    <IconLink icon="academic-cap" type="solid" to="#">
      Test123
    </IconLink>
    """
  end

@example [
    title: "active",
    height: "115px",
  ]

  @doc "An example of an active link."
  def active_example(assigns) do
    ~F"""
    <IconLink icon="flag" to="#" active>
      Test123
    </IconLink>
    """
  end

  @example [
    title: "long title",
    height: "115px",
  ]

  @doc "An example of link with a long title."
  def long_title_example(assigns) do
    ~F"""
    <IconLink icon="flag" to="#">
      Lorem ipsum dolor sit amet, consectetur adipisicing elit. Atque, similique?
    </IconLink>
    """
  end

end
