defmodule Radicula.Filtrator do
  alias Radicula.RedisSrv

  def filter_prime(value, type) do
    is_prime?(value)
    |> filter_prime(value, type)
  end

  def filter_prime(false, _value, _type), do: :ignore

  def filter_prime(true, value, type) do
    set(type, value)
  end

  # Helpers

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
