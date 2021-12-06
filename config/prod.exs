use Mix.Config

config :logger, level: :info

config :exredis,
  host: "redis",
  port: 6379,
  password: "",
  db: 0,
  reconnect: 10,
  max_queue: :infinity
