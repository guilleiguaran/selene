defmodule Selene.RegistryTest do
  use ExUnit.Case, async: true

  defmodule Forwarder do
    use GenEvent

    def handle_event(event, parent) do
      send parent, event
      {:ok, parent}
    end
  end

  setup do
    {:ok, manager} = GenEvent.start_link
    {:ok, registry} = Selene.Registry.start_link(manager)

    GenEvent.add_mon_handler(manager, Forwarder, self())
    {:ok, registry: registry}
  end

  test "spawns buckets", %{registry: registry} do
    assert Selene.Registry.lookup(registry, "bucket") == :error

    Selene.Registry.create(registry, "bucket")
    assert {:ok, bucket} = Selene.Registry.lookup(registry, "bucket")

    Selene.Bucket.put(bucket, "keyA", "value")
    assert Selene.Bucket.get(bucket, "keyA") == "value"
  end

  test "removes buckets on exit", %{registry: registry} do
    Selene.Registry.create(registry, "bucket")
    {:ok, bucket} = Selene.Registry.lookup(registry, "bucket")
    Agent.stop(bucket)

    assert Selene.Registry.lookup(registry, "bucket") == :error
  end

  test "send events on create and crash", %{registry: registry} do
    Selene.Registry.create(registry, "bucket")
    {:ok, bucket} = Selene.Registry.lookup(registry, "bucket")
    assert_receive {:create, "bucket", ^bucket}

    Agent.stop(bucket)
    assert_receive {:exit, "bucket", ^bucket}
  end
end
