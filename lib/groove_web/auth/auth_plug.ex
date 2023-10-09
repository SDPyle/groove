defmodule GrooveWeb.AuthPlug do
  use AshAuthentication.Plug, otp_app: :groove

  def handle_success(conn, _activity, user, _token) do
    conn
    |> store_in_session(user)
    |> send_resp(200, "Welcome back #{user.name}")
  end

  def handle_failure(conn, _activity, _reason) do
    conn
    |> send_resp(401, "Forbidden")
  end
end
