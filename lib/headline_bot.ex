defmodule HeadlineBot do
  use Marvin.Bot

  match {:direct, ~r/headlines/}

  def handle_message(message, slack) do
    case fetch_headlines do
      {:ok, headlines} ->
        Enum.map(headlines, &story_to_attachment/1)
        |> send_attachment(message.channel, slack)
    end
  end

  defp story_to_attachment(%{ "webTitle" => title, "webUrl" => url }) do
    %{ title: title,
       title_link: url }
  end

  defp fetch_headlines do
    HTTPoison.get(url) |> handle_response |> extract_headlines
  end

  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    {:ok, Poison.Parser.parse!(body)}
  end

  defp extract_headlines({:ok, data}) do
    {:ok, data["response"]["results"]}
  end

  defp url do
    "http://content.guardianapis.com/search?section=uk-news&api-key=#{key}"
  end

  defp key do
    Application.get_env(:marvin, :guardian_token)
  end
end
