use Mix.Config

config :logger, level: :info

config :exredis,
  host: "redis", #RedisHost
  port: 6379, #RedisPort
  password: "",
  db: "test", #RedisDB
  reconnect: 10,
  max_queue: :infinity
