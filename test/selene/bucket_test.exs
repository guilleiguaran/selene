defmodule Selene.BucketTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} = Selene.Bucket.start_link
    {:ok, bucket: bucket}
  end

  test "stores values by key", %{bucket: bucket} do
    assert Selene.Bucket.get(bucket, "keyA") == nil

    Selene.Bucket.put(bucket, "keyA", "foo")
    assert Selene.Bucket.get(bucket, "keyA") == "foo"
  end

  test "deletes values by key", %{bucket: bucket} do
    Selene.Bucket.put(bucket, "keyA", "foo")
    assert Selene.Bucket.delete(bucket, "keyA") == "foo"

    assert Selene.Bucket.get(bucket, "keyA") == nil
    assert Selene.Bucket.delete(bucket, "keyA") == nil
  end
end
