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




import_config "#{Mix.env()}.exs"
