defmodule PuhoyTest do
  use ExUnit.Case
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
    assert data =~ "211"
  end
end
