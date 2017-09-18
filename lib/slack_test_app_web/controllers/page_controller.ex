defmodule SlackTestAppWeb.PageController do
  use SlackTestAppWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
