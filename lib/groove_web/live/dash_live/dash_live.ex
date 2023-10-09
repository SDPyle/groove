defmodule GrooveWeb.DashLive do
  use GrooveWeb, :surface_live_view

  require Ash.Query

  alias GrooveWeb.Components.{
    IconStat,
    WorkingUser,
    ToggleWorking
  }

  alias Groove.{Work, Features}
  alias GrooveWeb.ViewModels.WorkingUserViewModel

  def mount(_params, _session, socket) do
    if connected?(socket) do
      GrooveWeb.Endpoint.subscribe("working_user:started")
      GrooveWeb.Endpoint.subscribe("working_user:ended")
    end

    user = socket.assigns.current_user

    working_user_ids =
      Work.WorkingUser
      |> Work.read!(actor: user)

    working_user_views =
      Enum.map(working_user_ids, fn working_user_id ->
        WorkingUserViewModel.create(working_user_id)
      end)

    points_left =
      Features.Feature
      |> Ash.Query.filter(status != :archived)
      |> Features.sum!(:points, actor: user) || 0

    duration =
      Work.WorkShift
      |> Work.sum!(:duration, actor: user) || Time.new!(0, 0, 0)

    {hours, minutes, _seconds} = Time.to_erl(duration)
    hours = hours + minutes / 60

    socket =
      socket
      |> assign(:working_user_views, working_user_views)
      |> assign(:points_left, points_left)
      |> assign(:hours, hours)
      |> assign(:num_working, Enum.count(working_user_ids))

    Process.send_after(self(), :tick, 1_000)
    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, assign(socket, page: :dash)}
  end

  def handle_event("stop_working", _, socket) do
    user = socket.assigns.current_user

    if is_user_working_here?(user.id, socket.assigns.working_user_views) do
      Work.WorkingUser
      |> Work.get!(user.id, actor: user)
      |> Work.WorkingUser.end!(actor: user)
    end

    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 1_000)

    {:noreply,
     update(socket, :working_user_views, fn working_user_views ->
       Enum.map(working_user_views, fn working_user ->
         %{
           working_user
           | shift_count: working_user.shift_count + 1,
             work_count: working_user.work_count + 1,
             total_count: working_user.total_count + 1
         }
       end)
     end)}
  end

  def handle_info(
        %{topic: "working_user:started", payload: %{payload: %{data: working_user}}},
        socket
      ) do
    working_user_views = socket.assigns.working_user_views

    case Enum.find(working_user_views, nil, fn working_user_view ->
           working_user_view.user_id == working_user.id
         end) do
      nil ->
        working_user_views = [WorkingUserViewModel.create(working_user) | working_user_views]

        socket =
          socket
          |> assign(working_user_views: working_user_views)
          |> update(:num_working, fn num_working -> num_working + 1 end)

        {:noreply, socket}

      _ ->
        working_user_views =
          Enum.map(working_user_views, fn working_user_view ->
            if working_user_view.user_id == working_user.id do
              WorkingUserViewModel.create(working_user)
            else
              working_user_view
            end
          end)

        socket =
          socket
          |> assign(working_user_views: working_user_views)
          |> update(:num_working, fn num_working -> num_working + 1 end)

        {:noreply, socket}
    end
  end

  def handle_info(
        %{topic: "working_user:ended", payload: %{payload: %{data: working_user}}},
        socket
      ) do
    socket =
      socket
      |> assign(
        :working_user_views,
        Enum.filter(socket.assigns.working_user_views, fn working_user_view ->
          working_user_view.user_id != working_user.id
        end)
      )
      |> update(:num_working, fn num_working -> num_working - 1 end)

    {:noreply, socket}
  end

  defp is_user_working_here?(id, working_users) do
    case(Enum.find(working_users, nil, fn working_user -> working_user.user_id == id end)) do
      nil ->
        false

      _ ->
        true
    end
  end
end
