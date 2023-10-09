defmodule GrooveWeb.Components.IconLink do
  @moduledoc """
  A styled link with an icon
  """
  use Surface.Component

  alias Surface.Components.LivePatch

  @doc "The main content slot"
  slot default

  @doc "The icon slot - corresponds to a heroicon"
  prop icon, :string

  @doc "The icon type"
  prop type, :string, values: ["outline", "solid", "mini"], default: "outline"

  @doc "Whether the link is active or not"
  prop active, :boolean, default: false

  @doc "Where the link routes to"
  prop to, :string, required: true

  def render(assigns) do
    ~F"""
    <LivePatch
      class={
        "py-2.7 text-sm flex items-center whitespace-nowrap rounded-lg px-4 text-slate-700 transition",
        "shadow-soft-xl font-semibold bg-white": @active
      }
      to={@to}
    >
      <div class={
        "shadow-soft-2xl mr-2 flex h-8 w-8 items-center justify-center rounded-lg bg-white bg-center stroke-0 text-center p-1.5 transition",
        "bg-gradient-to-tl from-purple-700 to-pink-500 text-white": @active
      }>
        <Heroicons.Surface.Icon name={@icon} type={@type} />
      </div>
      <span class="ml-1 duration-300 opacity-100 pointer-events-none ease-soft truncate">
        <#slot />
      </span>
    </LivePatch>
    """
  end
end
