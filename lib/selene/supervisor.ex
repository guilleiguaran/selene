defmodule Selene.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @manager_name Selene.EventManager
  @registry_name Selene.Registry
  @bucket_sup_name Selene.Bucket.Supervisor

  def init(:ok) do
    children = [
      worker(GenEvent, [[name: @manager_name]]),
      supervisor(Selene.Bucket.Supervisor, [[name: @bucket_sup_name]]),
      worker(Selene.Registry, [@manager_name, @bucket_sup_name, [name: @registry_name]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
