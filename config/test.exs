use Mix.Config

config :logger, level: :warn

config :exredis,
  host: "127.0.0.1",
  port: 6379,
  password: "",
  db: 0,
  reconnect: 10,
  max_queue: :infinity
