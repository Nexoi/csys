defmodule Core.CASConnector do
  @moduledoc """
  Documentation for CASConnector.
  """
  @cas_redirect_url "https://cas.sustc.edu.cn/cas/login"
  @cas_login_url "https://cas.sustc.edu.cn/cas/login"

  @headers_default [
    {"Connection", "keep-alive"},
    {"User-Agent", "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.99 Mobile Safari/537.36"},
    {"Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"},
    {"Host", "cas.sustc.edu.cn"},
    {"Cache-Control", "max-age=0"},
    {"Upgrade-Insecure-Requests", "1"},
    {"Content-Type", "application/x-www-form-urlencoded"},
    {"Origin", "https://cas.sustc.edu.cn"}
  ]

  @doc """
  获取 TGC
  """
  def obtain_tgc(uid, password) do
    try do
      %{
        tgc: cookie,
      } = take_cookie()
          |> do_login("#{uid}", "#{password}")
      {:ok, cookie}
    rescue
      e in _ -> {:error}
    end
    # cookie |> IO.inspect(label: ">> TGC:")
    # {:ok, cookie}
  end

  def do_login(%{execution: execution, cookie: cookie} = _param, uid, password) do
    form = [{"execution", execution},
            {"_eventId", "submit"},
            {"submit", "登录"},
            {"geolocation", ""},
            {"username", uid},
            {"password", password}]
    # |> IO.inspect
    {:ok, %{headers: headers}} = HTTPoison.post @cas_login_url, {:form, form}, [ {"Cookie", cookie} | @headers_default]
    {"Set-Cookie", cookie} = List.keyfind(headers, "Set-Cookie", 0)
    %{
      tgc: cookie
    }
  end

  def take_cookie do
    {:ok, %{body: body, headers: headers}} = HTTPoison.get @cas_redirect_url, @headers_default
    # IO.inspect(headers, label: ">>>> CAS Page Headers")
    # IO.inspect(body, label: ">>>> CAS Page Body")
    {"Set-Cookie", cookie} =
      List.keyfind(headers, "Set-Cookie", 0)
    {"value", execution} =
      body
      |> Floki.find("input[name=execution]")
      |> List.first
      |> Tuple.to_list
      |> List.flatten
      |> List.keyfind("value", 0)
    %{
      cookie: cookie,
      execution: execution
    }
  end
end
