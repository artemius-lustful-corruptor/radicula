defmodule Radicula.RedisApiTest do
  use ExUnit.Case

  alias Radicula.RedisSrv

  describe "basic redis clent tests" do
    setup do
      {:ok, client} = RedisSrv.start_link()

      context = %{
        random_n: :rand.uniform(1000) + 1,
        client: client
      }

      {:ok, context}
    end

    test "setting value to redis list" do
      range = 1..1000

      Enum.each(range, fn x ->
        n = :rand.uniform(1000) + 1
        RedisSrv.set(:list, n)
        RedisSrv.pop()
      end)

      assert RedisSrv.set(:list, "end") == "1"
      assert RedisSrv.pop() == "end"
    end

    test "setting value to redis set", %{random_n: n} do
      assert RedisSrv.set(:set, n) == "1"
      RedisSrv.remove(:stest, n)
      assert RedisSrv.get_members(:stest) == []
    end
  end
end
