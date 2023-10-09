defmodule GrooveWeb.Components.IconLinkTest do
  use GrooveWeb.ConnCase, async: true
  use Surface.LiveViewTest

  alias GrooveWeb.Components.IconLink

  test "renders link text" do
    html =
      render_surface do
        ~F"""
        <IconLink icon="user" to="/">
          test123
        </IconLink>
        """
      end

    assert html =~ "test123"
  end

  test "renders an icon" do
    html =
      render_surface do
        ~F"""
        <IconLink icon="user" to="/">
          test123
        </IconLink>
        """
      end

    assert html =~ "<svg"
  end

  test "uses patch" do
    html =
      render_surface do
        ~F"""
        <IconLink icon="user" to="/">
          test123
        </IconLink>
        """
      end

    assert html =~ "patch"
  end

  test "is different when active" do
    html =
      render_surface do
        ~F"""
        <IconLink icon="user" to="/">
          test123
        </IconLink>
        """
      end

    active_html =
      render_surface do
        ~F"""
        <IconLink icon="user" to="/" active>
          test123
        </IconLink>
        """
      end

    assert html != active_html
  end
end
