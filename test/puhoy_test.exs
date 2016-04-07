defmodule PuhoyTest do
  use ExUnit.Case
  alias Puhoy.Group
  doctest Puhoy

  setup do
    host = System.get_env("USENET_HOST")
    {:ok, conn, data} = Puhoy.connection(host, 119)
    {:ok, [conn: conn, data: data]}
  end

  defp authenticate(context) do
    username = System.get_env("USENET_USERNAME")
    password = System.get_env("USENET_PASSWORD")
    Puhoy.authenticate(context[:conn], username, password)
  end

  test "connect", context do
    assert context[:conn]
    assert context[:data] =~ "200"
  end

  test "authenticate", context do
    {status, data} = authenticate(context)
    assert status == :ok
    assert data =~ "281"
  end

  test "bad command", context do
    authenticate(context)
    {status, data} = Puhoy.command(context[:conn], "FOO")
    assert status == :ok
    assert data =~ "400"
  end

  test "good command", context do
    {status, data} = Puhoy.command(context[:conn], "QUIT")
    assert status == :ok
    assert data =~ "205"
  end

  test "capabilities", context do
    {status, data} = Puhoy.capabilities(context[:conn])
    assert status == :ok
    assert data =~ "101"
  end

  test "mode_reader", context do
    {status, data} = Puhoy.mode_reader(context[:conn])
    assert status == :ok
    assert data =~ "201"
  end

  test "quit", context do
    {status, data} = Puhoy.quit(context[:conn])
    assert status == :ok
    assert data =~ "205"
  end

  test "group", context do
    authenticate(context)
    {status, data} = Puhoy.group(context[:conn], "news.software.nntp")
    assert status == :ok
    assert data.__struct__ == %Group{}.__struct__
  end

  test "body", context do
    authenticate(context)
    {status, data} = Puhoy.body(context[:conn], "<bdrdj3$bpd$1@ctb-nnrp2.saix.net>")
    assert status == :ok
    assert data == "Good day,\r\nIm setting up INND on Redhat 7.3 for a corporate LAN,\r\n" <>
                   "did a makehistory (as news) - OK\r\nwhen I do a makedbz (as news/root) I get -    \"" <>
                   "Cant do dbzagain, No such\r\nfile or directory\"\r\n\r\nI've check perms (644 - news)\r\n\r\n" <>
                   "Any idea,\r\n\r\nTIA\r\n\r\nDAN\r\n\r\n\r\n"
  end
end
