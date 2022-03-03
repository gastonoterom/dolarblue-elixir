defmodule HttpServer.Router do
  use Plug.Router
  use Plug.Debugger
  require Logger
  plug(Plug.Logger, log: :debug)

  plug(:match)

  plug(:dispatch)

  ########################################################################################
  # ROUTES

  get "/" do
    send_resp(conn, 200, Poison.encode!(Dolarblue.Interface.get_average()))
  end

  get "/data" do
    send_resp(conn, 200, Poison.encode!(Dolarblue.Interface.get_data()))
  end

  get "/report" do
    send_resp(conn, 200, Poison.encode!(Dolarblue.Interface.get_report()))
  end

  ########################################################################################

  match _ do
    send_resp(conn, 404, "not found")
  end
end
