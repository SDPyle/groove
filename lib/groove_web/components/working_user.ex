defmodule GrooveWeb.Components.WorkingUser do
  use Surface.Component

  @moduledoc """
  A widget for displaying a working user.
  """

  @doc "The user's name"
  prop name, :string, default: ""
  @doc "The title of the work the user is working on"
  prop work_title, :string, default: ""
  @doc "The amount of time the user has spent on the current shift"
  prop shift_count, :integer, default: 0
  @doc "The amount of time the user has spent on the current work"
  prop work_count, :integer, default: 0
  @doc "The total amount of time the user has spent working"
  prop total_count, :integer, default: 0

  def render(assigns) do
    ~F"""
    <div class="card p-4 min-w-min">
      <div class="flex justify-between items-center">
        <h5>{@name}</h5>
        <div>
          <p class="m-0 text-center text-sm font-semibold leading-none">Total</p>
          <p class="m-0">{format_count(@total_count)}</p>
        </div>
      </div>
      <hr class="h-px my-2 bg-transparent bg-gradient-to-r from-transparent via-black/40 to-transparent">
      <div>
        <p class="m-0 text-sm font-semibold text-center leading-none">{@work_title}</p>
        <div class="flex justify-between">
          <p class="m-0">{format_count(@shift_count)}</p>
          <p class="m-0">{format_count(@work_count)}</p>
        </div>
      </div>
    </div>
    """
  end

  defp format_count(count) do
    hours =
      div(count, 3600)
      |> Integer.to_string()
      |> String.pad_leading(2, "0")

    minutes =
      div(rem(count, 3600), 60)
      |> Integer.to_string()
      |> String.pad_leading(2, "0")

    seconds =
      rem(count, 60)
      |> Integer.to_string()
      |> String.pad_leading(2, "0")

    "#{hours}:#{minutes}:#{seconds}"
  end
end
