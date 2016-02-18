defmodule EchoBot do
  use Marvin.Bot

  match {:direct, ~r/hello/}

  def handle_message(message, slack) do
    send_message("Hi!", message.channel, slack)
  end
end
