defmodule Selene.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, registry} = Selene.Registry.start_link
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
end
