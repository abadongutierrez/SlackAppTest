defmodule SlackTestAppWeb.AuthController do
    use SlackTestAppWeb, :controller
  
  def index(conn, _params) do
    redirect conn, external: authorize_url!()
  end

  def callback(conn, %{"state" => state, "code" => code}) do
    client = get_token!(code)
    render conn, "callback.html", bot: get_bot_info(client)
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  defp authorize_url! do
    client()
    |> OAuth2.Client.authorize_url!(scope: "channels:read chat:write:bot im:read im:write users:read users:write bot", state: "123")
  end

  defp get_token!(code) do
    client = client()
    client
    |> OAuth2.Client.get_token!(code: code, client_secret: client.client_secret)
  end

  defp get_bot_info(client) do
    response = "https://slack.com/api/bots.info?token=#{client.token.other_params["bot"][""bot_access_token"]}"
    |> HttpPoison.get

    case response do
      {:ok, %HTTPoison.Response{body: body}} -> body["bot"]["name"]
      {:error, _} -> "Error"
    end
  end

  defp client do
    client = OAuth2.Client.new([
      strategy: OAuth2.Strategy.AuthCode,
      client_id: System.get_env("SLACK_CLIENT_ID"),
      client_secret: System.get_env("SLACK_CLIENT_SECRET"),
      site: "https://slack.com",
      authorize_url: "/oauth/authorize",
      token_url: "/api/oauth.access",
      redirect_uri: "https://slacktestappbot.herokuapp.com/auth/callback",
    ])
  end
end
  