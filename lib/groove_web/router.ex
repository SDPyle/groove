defmodule GrooveWeb.Router do
  use GrooveWeb, :router

  import Surface.Catalogue.Router
  use AshAuthentication.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {GrooveWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_from_session
  end

  scope "/", GrooveWeb do
    pipe_through :browser

    ash_authentication_live_session :authentication_required,
      on_mount: {GrooveWeb.LiveUserAuth, :live_profile_required} do
      live "/", DashLive
      live "/backlog", BacklogLive
      live "/backlog/:id", FeatureLive
    end

    ash_authentication_live_session :confirmed_user_required,
      on_mount: {GrooveWeb.LiveUserAuth, :live_confirmed_user_required} do
      live "/profile", ProfileLive
    end

    sign_in_route()
    sign_out_route AuthController
    auth_routes_for Groove.Accounts.User, to: AuthController
    reset_route []
    live "/demo", Demo

    live "/verify-email", VerifyEmailLive
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:groove, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: GrooveWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  if Mix.env() == :dev do
    scope "/" do
      pipe_through :browser
      surface_catalogue("/catalogue")
    end
  end
end
