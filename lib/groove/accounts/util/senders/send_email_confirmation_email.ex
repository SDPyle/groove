defmodule Groove.Accounts.Senders.SendEmailConfirmationEmail do
  @moduledoc """
  Sends a email confirmation email
  """
  use AshAuthentication.Sender
  use GrooveWeb, :verified_routes

  @impl AshAuthentication.Sender
  def send(user, token, _) do
    Groove.Accounts.Emails.deliver_email_confirmation(
      user,
      url(~p"/auth/user/confirm?confirm=#{token}")
    )
  end
end
