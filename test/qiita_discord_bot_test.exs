defmodule QiitaDiscordBotTest do
  use ExUnit.Case
  doctest QiitaDiscordBot

  test "greets the world" do
    assert QiitaDiscordBot.hello() == :world
  end
end
