defmodule GrooveWeb.FeatureLive do
  use GrooveWeb, :surface_live_view
  require Ash.Query

  alias Groove.Features
  alias Groove.Work
  alias GrooveWeb.ViewModels.WorkingUserViewModel
  alias GrooveWeb.Components.{WorkingUser, ToggleWorking}

  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      GrooveWeb.Endpoint.subscribe("feature:updated")
      GrooveWeb.Endpoint.subscribe("working_user:started:" <> id)
      GrooveWeb.Endpoint.subscribe("working_user:ended:" <> id)
    end

    user = socket.assigns.current_user

    working_user_ids =
      Work.WorkingUser
      |> Ash.Query.filter(work_id == ^id)
      |> Work.read!(actor: user)

    working_user_views =
      Enum.map(working_user_ids, fn working_user_id ->
        WorkingUserViewModel.create(working_user_id)
      end)

    socket =
      socket
      |> assign(page: :backlog)
      |> assign(show_edit_feature_modal: false)
      |> assign(:working_user_views, working_user_views)
      |> assign(:id, id)

    Process.send_after(self(), :tick, 1_000)
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    user = socket.assigns.current_user

    case Features.get(Features.Feature, id, actor: user) do
      {:ok, feature} ->
        user = socket.assigns.current_user
        form = AshPhoenix.Form.for_update(feature, :update, api: Features, actor: user)

        rendered_description = Earmark.as_html!(feature.description)

        socket =
          assign(socket,
            feature: feature,
            rendered_description: rendered_description,
            edit_feature_form: form
          )

        {:noreply, socket}

      {:error, _} ->
        {:noreply, redirect(socket, to: ~p"/backlog")}
    end
  end

  def handle_event("toggle_show_edit_feature_modal", _, socket) do
    {:noreply,
     update(socket, :show_edit_feature_modal, fn show_edit_feature_modal ->
       !show_edit_feature_modal
     end)}
  end

  def handle_event("validate", %{"form" => params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.edit_feature_form, params)
    {:noreply, assign(socket, edit_feature_form: form)}
  end

  def handle_event("update_feature", %{"form" => params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.edit_feature_form, params)

    case AshPhoenix.Form.submit(form) do
      {:ok, feature} ->
        new_form =
          AshPhoenix.Form.for_update(feature, :update,
            api: Features,
            actor: socket.assigns.current_user
          )

        rendered_description = Earmark.as_html!(feature.description)

        {:noreply,
         assign(socket,
           feature: feature,
           rendered_description: rendered_description,
           edit_feature_form: new_form,
           show_edit_feature_modal: false
         )}

      {:error, form} ->
        {:noreply, assign(socket, edit_feature_form: form)}
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
          Work.WorkingUser.start!(socket.assigns.id, actor: user)

        {:error, _} ->
          Work.WorkingUser.start!(socket.assigns.id, actor: user)
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
        %{topic: "feature:updated", payload: %{payload: %{data: feature}}},
        socket
      ) do
    {:noreply, assign(socket, feature: feature)}
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
