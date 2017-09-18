defmodule SlackTestAppWeb.AuthController do
    use SlackTestAppWeb, :controller
  
  def index(conn, _params) do
    redirect conn, external: authorize_url!()
  end

  def callback(conn, %{"state" => provider, "code" => code}) do
    client = get_token!(code)
    text conn, "Token #{client.token}"
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  defp authorize_url! do
    client()
    |> OAuth2.Client.authorize_url!(scope: "channels:read chat:write:bot im:read im:write users:read users:write", state: "123")
  end

  defp get_token!(code) do
    client()
    |> OAuth2.Client.get_token!(code: code)
  end

  defp client do
    client = OAuth2.Client.new([
      strategy: OAuth2.Strategy.AuthCode, #default
      client_id: "13627763665.235076033200",
      client_secret: "2b74edbed9d16723665e54b80cc2ac34",
      site: "https://slack.com",
      authorize_url: "/oauth/authorize",
      token_url: "/api/oauth.access",
      redirect_uri: "https://slacktestappbot.herokuapp.com/auth/callback",
    ])
  end
end
  