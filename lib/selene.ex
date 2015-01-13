defmodule Selene do
  use Application

  def start(_type, _args) do
    Selene.Supervisor.start_link
  end
end
