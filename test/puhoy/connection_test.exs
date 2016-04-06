defmodule PuhoyConnectionTest do
  use ExUnit.Case
  doctest Puhoy

  test "connection" do
    {:ok, listener} = :gen_tcp.listen(0, [active: false, mode: :binary])
    {:ok, port} = :inet.port(listener)
    {:ok, conn} = Puhoy.Connection.start_link({127,0,0,1}, port, [mode: :binary])
    {:ok, socket} = :gen_tcp.accept(listener, 1000)

    assert :gen_tcp.send(socket, "hello") == :ok
    assert Puhoy.Connection.recv(conn, 5, 1000) == {:ok, "hello"}
    assert Puhoy.Connection.send(conn, "hi") == :ok
    assert :gen_tcp.recv(socket, 2, 1000) == {:ok, "hi"}
    assert Puhoy.Connection.close(conn) == :ok
    assert :gen_tcp.recv(socket, 0, 1000) == {:error, :closed}

    {:ok, socket} = :gen_tcp.accept(listener, 1000)

    assert Puhoy.Connection.send(conn, "back!") == :ok
    assert :gen_tcp.recv(socket, 5, 1000) == {:ok, "back!"}
  end
end
