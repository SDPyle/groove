defmodule GrooveWeb.Components.ToggleWorking do
  @moduledoc """
  A styled button for a user to start working or stop working.
  """
  use Surface.Component

  @doc "Event for the user's click"
  prop click, :event, required: true

  @doc "Is the user working here"
  prop is_working_here, :boolean, required: true

  def render(assigns) do
    ~F"""
    <button class="border border-slate-200 py-4 border-dashed rounded-2xl w-full" :on-click={@click}>
      {#if @is_working_here}
        <p class="p-0 m-0">Stop Working</p>
      {#else}
        <p class="p-0 m-0">Start Working Here</p>
      {/if}
    </button>
    """
  end
end
