defmodule Radicula.Application do
  use Application

  def start(_type, _args) do
    children =
      case Application.get_env(:radicula, :environment) do
        :prod ->
          s = Application.get_env(:radicula, :servers)
          b = Application.get_env(:radicula, :bound)

          [
            Radicula.RedisSrv,
            {Radicula.GeneratorSuperviser, %{servers: s, bound: b}},
            Radicula.FiltratorSrv
          ]

        _ ->
          []
      end

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
