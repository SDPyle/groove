defmodule GrooveWeb.BacklogLive do
  use GrooveWeb, :surface_live_view

  require Ash.Query
  alias Surface.Components.{LiveRedirect}
  alias Groove.Features
  alias Groove.Work
  alias GrooveWeb.ViewModels.WorkingUserViewModel
  alias GrooveWeb.Components.{StatusPill, WorkingUser, ToggleWorking}

  @backlog_work_id WorkingUserViewModel.get_backlog_work_id()

  def mount(_params, _session, socket) do
    if connected?(socket) do
      GrooveWeb.Endpoint.subscribe("feature:created")
      GrooveWeb.Endpoint.subscribe("feature:updated")
      GrooveWeb.Endpoint.subscribe("feature:destroyed")
      GrooveWeb.Endpoint.subscribe("working_user:started:" <> @backlog_work_id)
      GrooveWeb.Endpoint.subscribe("working_user:ended:" <> @backlog_work_id)
    end

    user = socket.assigns.current_user
    form = AshPhoenix.Form.for_create(Features.Feature, :create, api: Features, actor: user)

    backlog = Features.Feature.list_recent!(actor: user)

    # get working users
    working_user_ids =
      Work.WorkingUser
      |> Ash.Query.filter(work_id == @backlog_work_id)
      |> Work.read!(actor: user)

    working_user_views =
      Enum.map(working_user_ids, fn working_user_id ->
        WorkingUserViewModel.create(working_user_id)
      end)

    socket =
      socket
      |> assign(:backlog, backlog)
      |> assign(new_feature_form: form)
      |> assign(:working_user_views, working_user_views)

    Process.send_after(self(), :tick, 1_000)
    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply,
     assign(socket,
       page: :backlog,
       show_new_feature_modal: false
     )}
  end

  def handle_event("toggle_show_new_feature_modal", _, socket) do
    {:noreply,
     update(socket, :show_new_feature_modal, fn show_new_feature_modal ->
       !show_new_feature_modal
     end)}
  end

  def handle_event("validate", %{"form" => params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.new_feature_form, params)
    {:noreply, assign(socket, new_feature_form: form)}
  end

  def handle_event("save_new_feature", %{"form" => params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.new_feature_form, params)

    case AshPhoenix.Form.submit(form) do
      {:ok, _} ->
        new_form =
          AshPhoenix.Form.for_create(Features.Feature, :create,
            api: Features,
            actor: socket.assigns.current_user
          )

        {:noreply,
         assign(socket,
           new_feature_form: new_form
         )}

      {:error, form} ->
        {:noreply, assign(socket, new_feature_form: form)}
    end
  end

  def handle_event("toggle_working", _, socket) do
    user = socket.assigns.current_user

    if is_user_working_here?(user.id, socket.assigns.working_user_views) do
      Work.WorkingUser
      |> Work.get!(user.id, actor: user)
      |> Work.WorkingUser.end!(actor: user)
    else
      case Work.get(Work.WorkingUser, user.id, actor: user) do
        {:ok, working_user} ->
          Work.WorkingUser.end!(working_user, actor: user)
          Work.WorkingUser.start!(@backlog_work_id, actor: user)

        {:error, _} ->
          Work.WorkingUser.start!(@backlog_work_id, actor: user)
      end
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
        %{topic: "feature:created", payload: %{payload: %{data: feature}}},
        socket
      ) do
    {:noreply, update(socket, :backlog, fn backlog -> [feature | backlog] end)}
  end

  def handle_info(
        %{topic: "feature:updated", payload: %{payload: %{data: feature}}},
        socket
      ) do
    {:noreply,
     update(socket, :backlog, fn backlog ->
       [feature | Enum.reject(backlog, fn f -> f.id == feature.id end)]
     end)}
  end

  def handle_info(
        %{topic: "working_user:started:" <> _, payload: %{payload: %{data: working_user}}},
        socket
      ) do
    working_user_views = socket.assigns.working_user_views

    case Enum.find(working_user_views, nil, fn working_user_view ->
           working_user_view.user_id == working_user.id
         end) do
      nil ->
        working_user_views = [WorkingUserViewModel.create(working_user) | working_user_views]
        {:noreply, assign(socket, working_user_views: working_user_views)}

      _ ->
        working_user_views =
          Enum.map(working_user_views, fn working_user_view ->
            if working_user_view.user_id == working_user.id do
              WorkingUserViewModel.create(working_user)
            else
              working_user_view
            end
          end)

        {:noreply, assign(socket, working_user_views: working_user_views)}
    end
  end

  def handle_info(
        %{topic: "working_user:ended:" <> _, payload: %{payload: %{data: working_user}}},
        socket
      ) do
    {:noreply,
     assign(
       socket,
       :working_user_views,
       Enum.filter(socket.assigns.working_user_views, fn working_user_view ->
         working_user_view.user_id != working_user.id
       end)
     )}
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
