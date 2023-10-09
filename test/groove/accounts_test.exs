defmodule Groove.AccountsTest do
  alias Swoosh.Email
  use Groove.DataCase

  require Ash.Query
  require Logger

  import Swoosh.TestAssertions

  alias AshAuthentication.{Info, Strategy}
  alias Groove.Accounts

  describe "user registration" do
    @valid_attrs %{
      "email" => "test@test",
      "password" => "thisIsAGoodPassword123",
      "password_confirmation" => "thisIsAGoodPassword123"
    }
    @invalid_attrs %{"email" => "bademail", "password" => "bad", "password_confirmation" => "bad"}

    test "should register new users" do
      {:ok, user} = register(@valid_attrs)
      repo_user = get_user(user.id)
      assert repo_user.email |> to_string == "test@test"
      assert repo_user.confirmed_at == nil
    end

    test "should send a verification email" do
      {:ok, user} = register(@valid_attrs)

      # @TODO assert specific email; doesn't seem to work
      # email =
      #   Email.new(
      #     subject: "Confirm Your Email",
      #     from: {"Groove", "groove@groove.org"},
      #     to: [{"", "test@test"}],
      #     cc: [],
      #     bcc: [],
      #     text_body: nil,
      #     html_body:
      #       "<html>\n  <p>\n    Hi test@test,\n  </p>\n\n  <p>\n    <a href=\"http://localhost:4002/auth/user/confirm?confirm=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY3QiOiJjb25maXJtIiwiYXVkIjoifj4gMy4xMSIsImV4cCI6MTY5NTc1NjIwNiwiaWF0IjoxNjk1NDk3MDA2LCJpc3MiOiJBc2hBdXRoZW50aWNhdGlvbiB2My4xMS4xNSIsImp0aSI6IjJ1M3ByMnJnNDlhNnBwZG82YzAwMDBhYSIsIm5iZiI6MTY5NTQ5NzAwNiwic3ViIjoiY3JlZGVudGlhbD9pZD05YjRjMThjYy0xNzkyLTRmZWMtOGNjMy02YjU5MTFkZjAwYzAifQ.0AJ52d6t3I_utVLhR3BsbqW22BdO0mmXqHLOsNzZPmo\">Click here</a> to confirm your email.\n  </p>\n\n  <p>\n    If you didn't request this change, please ignore this.\n  </p>\n<html>\n",
      #     headers: %{},
      #     assigns: %{},
      #     provider_options: %{track_links: "None"}
      #   )

      # assert_email_sent(email)
      assert_email_sent()
    end

    test "should not allow invalid email and password" do
      {:error, err} = register(@invalid_attrs)
      assert Enum.count(err.errors) == 3
    end

    test "should verify with confirmation action using confirmation token" do
      {:ok, user} = register(@valid_attrs)
      confirm(user)
      user = get_user(user.id)

      assert user.email |> to_string == "test@test"
      assert user.confirmed_at != nil
    end
  end

  defp register(attrs) do
    strategy = Info.strategy!(Groove.Accounts.User, :password)
    Strategy.action(strategy, :register, attrs)
  end

  defp confirm(user) do
    confirmStrategy = Info.strategy!(Accounts.User, :confirm)

    Strategy.action(confirmStrategy, :confirm, %{
      "confirm" => user.__metadata__.confirmation_token
    })
  end

  defp get_user(id) do
    Accounts.User
    |> Ash.Query.filter(id == ^id)
    |> Accounts.read_one!()
  end
end
