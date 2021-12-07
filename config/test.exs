use Mix.Config

config :logger, level: :warn

config :exredis,
  host: "127.0.0.1", #RedisHost
  port: 6379, #RedisPort
  password: "",
  db: 0, #RedisDB
  reconnect: 10,
  max_queue: :infinity
