defmodule GrooveWeb.Components.IconStat do
  @moduledoc """
  A component for displaying statistics with a styled icon
  """
  use Surface.Component

  @doc "The header"
  prop header, :string, required: true

  @doc "The stat being displayed"
  prop stat, :number, required: true

  @doc "The type of stat being displayed"
  prop stat_type, :atom, values: [:int, :float], default: :int

  @doc "The icon - corresponds to a heroicon"
  prop icon, :string, required: true

  @doc "The icon type"
  prop icon_type, :string, values: ["outline", "solid", "mini"], default: "outline"

  def render(assigns) do
    ~F"""
    <div class="relative flex flex-col min-w-0 break-words bg-white shadow-soft-xl rounded-2xl bg-clip-border">
      <div class="flex-auto p-4">
        <div class="flex justify-between">
          <div class="flex-none px-3">
            <div>
              <p class="mb-0 font-sans font-semibold leading-normal text-sm">{@header}</p>
              <h5 class="mb-0 font-bold">
                {format_stat(@stat, @stat_type)}
              </h5>
            </div>
          </div>
          <div class="px-3 text-right">
            <div class="inline-block flex justify-center my-auto w-12 h-12 text-white text-center rounded-lg bg-gradient-to-tl from-purple-700 to-pink-500">
              <div class="w-6 h-full flex align-middle">
                <Heroicons.Surface.Icon name={@icon} type={@icon_type} />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp format_stat(stat, stat_type) do
    case stat_type do
      :int ->
        Number.Delimit.number_to_delimited(stat, precision: 0)

      :float ->
        Number.Delimit.number_to_delimited(stat, precision: 1)
    end
  end
end
