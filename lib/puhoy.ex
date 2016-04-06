defmodule Puhoy do
  alias Puhoy.{Connection, Group}
  @doc """
    https://tools.ietf.org/html/rfc3977
  """

  def connection(host, port) do
    case Connection.start_link(String.to_char_list(host), port, [mode: :binary]) do
      {:ok, conn} ->
        {_, data} = Connection.recv(conn, 0, 1000)
        {:ok, conn, data}
      {:error, reason} -> {:error, reason}
    end
  end

  def authenticate(conn, username, password) do
    command(conn, "AUTHINFO USER #{username}" <> "\r\n")
    command(conn, "AUTHINFO PASS #{password}" <> "\r\n")
  end

  def command(conn, command) do
    Connection.send(conn, command <> "\r\n")
    Connection.recv(conn, 0, 1000)
  end

  def capabilities(conn), do: command(conn, "CAPABILITIES")
  def mode_reader(conn), do: command(conn, "MODE READER")
  def quit(conn), do: command(conn, "QUIT")
  def group(conn, group) do
    {status, response} = command(conn, "GROUP #{group}")
    {status, Group.from_response(response)}
  end
end
