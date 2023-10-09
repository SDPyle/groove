defmodule GrooveWeb.ProfileLive do
  use GrooveWeb, :surface_live_view

  alias Groove.Profiles
  alias Surface.Components.Form

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user

    socket =
      socket
      |> assign(page: :profile)
      |> init_form(user)

    {:ok, socket}
  end

  def handle_event("validate", %{"form" => params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, params)
    {:noreply, assign(socket, form: form)}
  end

  def handle_event("save", %{"form" => params}, socket) do
    params = Map.put(params, "id", socket.assigns.current_user.id)
    form = AshPhoenix.Form.validate(socket.assigns.form, params)

    case AshPhoenix.Form.submit(form) do
      {:ok, result} ->
        form =
          result
          |> AshPhoenix.Form.for_update(:update,
            api: Profiles,
            actor: socket.assigns.current_user,
            forms: [auto?: true]
          )

        {:noreply, assign(socket, form: form)}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp init_form(socket, user) do
    case Profiles.get(Profiles.Profile, user.id, actor: user) do
      {:ok, profile} ->
        assign(socket,
          form:
            AshPhoenix.Form.for_update(profile, :update,
              api: Profiles,
              actor: user,
              forms: [auto?: true]
            )
        )

      {:error, _} ->
        assign(socket,
          form:
            AshPhoenix.Form.for_create(Profiles.Profile, :create,
              api: Profiles,
              actor: user,
              forms: [auto?: true]
            )
        )
    end
  end
end
