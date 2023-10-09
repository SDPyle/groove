defmodule GrooveWeb.Components.IconLinkTest do
  use GrooveWeb.ConnCase, async: true
  use Surface.LiveViewTest

  alias GrooveWeb.Components.IconStat

  test "renders a header" do
    html =
      render_surface do
        ~F"""
        <IconStat header="Header 1" stat="123" icon="user" />
        """
      end

    assert html =~ "Header 1"
  end

  test "renders a stat" do
    html =
      render_surface do
        ~F"""
        <IconStat header="Header 1" stat="123" icon="user" />
        """
      end

    assert html =~ "123"
  end

  test "renders an icon" do
    html =
      render_surface do
        ~F"""
        <IconStat header="Header 1" stat="123" icon="user" />
        """
      end

    assert html =~ "<svg"
  end
end
