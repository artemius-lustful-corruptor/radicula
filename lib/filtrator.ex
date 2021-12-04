defmodule Radicula.Filtrator do
  @moduledoc """
  Module for Filtrator functions
  """
  require Logger

  alias Radicula.RedisSrv

  @spec filter_prime(String.t(), atom()) :: {:ok, :filtered}
  def filter_prime(value, type)

  def filter_prime(value, type) do
    integer = String.to_integer(value)

    is_prime?(integer)
    |> filter_prime(integer, type)

    {:ok, :filtered}
  end

  # Helpers

  defp filter_prime(false, _value, _type), do: :ignore

  defp filter_prime(true, value, type) do
    Logger.info("""
    Value: #{value} is prime. 
    Going to write that to Redis set
    """)

    set(type, value)
  end

  defp is_prime?(value) when value < 2, do: false
  defp is_prime?(value), do: is_prime?(value, 2)
  defp is_prime?(value, value), do: true

  defp is_prime?(value, rem_factor) do
    prime_remainder = rem(value, rem_factor)

    case prime_remainder == 0 do
      true -> false
      _ -> is_prime?(value, rem_factor + 1)
    end
  end

  defp set(value, type) do
    RedisSrv.set(value, type)
  end
end
