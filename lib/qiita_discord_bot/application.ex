defmodule QiitaDiscordBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  defmodule Commands do
    use Alchemy.Cogs

    Cogs.def ping do
      Cogs.say "pong!"
    end

    Cogs.def qiita(key) do
      key = String.downcase(key)
      Cogs.say "#{key}の先週のトレンド"
      target_url = "https://qiita.com/tags/" <> key
      HTTPoison.get!(target_url).body
      |> Floki.find("a.css-eebxa")
      |> Floki.attribute("href")
      |> Enum.each(&(Cogs.say(&1)))
    end
  end


  def start(_type, _args) do
    children = [
      # Starts a worker by calling: QiitaDiscordBot.Worker.start_link(arg)
      # {QiitaDiscordBot.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: QiitaDiscordBot.Supervisor]
    Supervisor.start_link(children, opts)

    token = Application.get_env(:qiita_discord_bot, :discord_token)
    run = Alchemy.Client.start(token)
    use Commands
    run
  end
end
