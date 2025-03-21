defmodule RaffleyWeb.Router do
  use RaffleyWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {RaffleyWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:spy)
  end

  def spy(conn, _otp) do
    message =
      ~w(hello hi howdy)
      |> Enum.random()

    conn =
      assign(conn, :message, message)

    conn
    # |> IO.inspect()
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", RaffleyWeb do
    pipe_through(:browser)

    # get("/", PageController, :home)
    live("/", Rafflelive.Index)
    get("/rules", RulesController, :index)
    get("/rules/:id", RulesController, :show)
    live("/estimator", EstimatorLive)
    live("/raffleylist", Rafflelive.Index)
    live("/raffleylist/:id", Rafflelive.Show)
    live("/admin/raffles", AdminRafflelive.Index)
    live("/admin/raffles/new", AdminRafflelive.Form, :new)
    live("/admin/raffles/edit/:id", AdminRafflelive.Form, :edit)
    live "/charities", CharityLive.Index, :index
    live "/charities/new", CharityLive.Form, :new
    live "/charities/:id", CharityLive.Show, :show
    live "/charities/:id/edit", CharityLive.Form, :edit
  end

  # Other scopes may use custom stacks.
  scope "/api", RaffleyWeb do
    pipe_through(:api)
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:raffley, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: RaffleyWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
