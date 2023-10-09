defmodule GrooveWeb.Components.StatusPillTest do
  use GrooveWeb.ConnCase, async: true
  use Surface.LiveViewTest

  alias GrooveWeb.Components.StatusPill

  test "renders new" do
    html =
      render_surface do
        ~F"""
        <StatusPill status={:new} />
        """
      end

    assert html =~ "New"
  end

  test "renders ready" do
    html =
      render_surface do
        ~F"""
        <StatusPill status={:ready} />
        """
      end

    assert html =~ "Ready"
  end

  test "renders in progress" do
    html =
      render_surface do
        ~F"""
        <StatusPill status={:in_progress} />
        """
      end

    assert html =~ "In Progress"
  end

  test "renders needs review" do
    html =
      render_surface do
        ~F"""
        <StatusPill status={:needs_review} />
        """
      end

    assert html =~ "Needs Review"
  end

  test "renders completed" do
    html =
      render_surface do
        ~F"""
        <StatusPill status={:completed} />
        """
      end

    assert html =~ "Completed"
  end

  test "renders archived" do
    html =
      render_surface do
        ~F"""
        <StatusPill status={:archived} />
        """
      end

    assert html =~ "Archived"
  end
end
