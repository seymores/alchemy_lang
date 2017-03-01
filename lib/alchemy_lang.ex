defmodule Alchemy do
  require Logger

  @moduledoc """
  Documentation for Alchemy.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Alchemy.hello
      :world

  """
  def combine(params) do
    # https://gateway-a.watsonplatform.net/calls/url/URLGetRankedNamedEntities?apikey=daf87d961a104f7b91253512b1e7e97da816aeee&url=http://www.thestar.com.my/news/nation/2017/03/01/19-file-action-to-get-zakir-naik-declared-a-threat-to-national-security&outputMode=json
    api_key = Application.get_env(:alchemy_lang, :api_key)
    options = [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 5000]
    url = "https://gateway-a.watsonplatform.net/calls/url/URLGetRankedNamedEntities?apikey=#{api_key}&outputMode=json"

    Logger.debug url

    params_list =
      (for {k, v} <- params, do: "#{k}=#{v}") |> Enum.join("&")

    case HTTPoison.post(url, params_list, [], options) do
    # case HTTPoison.post(url, params_list) do
      {:ok, response} -> response.body |> Poison.decode!
      {_, msg} -> msg
    end
  end
end
