use Mix.Config

config :radicula,
  # ms
  interval: 1000,
  batch_size: 1000,
  redis_list: :ltest,
  redis_set: :stest,
  bound: 1000,
  servers: 3000,
  environment: Mix.env()

config :logger, level: :info

config :exredis,
  host: "127.0.0.1",
  port: 6379,
  password: "",
  db: 0,
  reconnect: :no_reconnect,
  max_queue: :infinity
