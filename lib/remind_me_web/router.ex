defmodule RemindMeWeb.Router do
  use RemindMeWeb, :router
  use Plug.ErrorHandler
  use Sentry.Plug

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(Phauxth.Authenticate)
    plug(Phauxth.Remember)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", RemindMeWeb do
    pipe_through(:browser)

    # Home page and dashboard
    get("/", HomeController, :index)
    get("/dashboard", HomeController, :dashboard)

    # Core CRUD operations
    resources("/users", UserController)
    resources("/server_numbers", ServerNumberController)
    resources("/connections", ConnectionController)
    resources("/destinations", DestinationController)
    resources("/client_numbers", ClientNumberController)
    resources("/events", EventController, except: [:show])

    # Authentication concerns
    resources("/sessions", SessionController, only: [:new, :create, :delete])
    get("/confirm", ConfirmController, :index)
    resources("/password_resets", PasswordResetController, only: [:new, :create])
    get("/password_resets/edit", PasswordResetController, :edit)
    put("/password_resets/update", PasswordResetController, :update)
  end

  scope "/api", RemindMeWeb do
    pipe_through(:api)

    get("/message-receive", MessageReceiveController, :process)
    post("/sendgrid-events", SendgridEventController, :process)
    post("/inbound-parse", InboundParseController, :new)
  end
end
