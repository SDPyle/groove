defmodule GrooveWeb.VerifyEmailLive do
  use Surface.LiveView

  alias GrooveWeb.Components.Card

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~F"""
    <div class="flex justify-center mt-12">
      <Card rounded max_width="lg">
        <:header>
          Verify Email
        </:header>

        You must verify your email.
      </Card>
    </div>
    """
  end
end
