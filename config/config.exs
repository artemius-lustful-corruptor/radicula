use Mix.Config

config :radicula,
  interval: 1000, #ms
  batch_size: 1000,
  redis_list: :ltest2, #QueueKey
  redis_set: :stest2, #ResultSetKey
  bound: 1000,  # N
  servers: 3000, 
  environment: Mix.env()




import_config "#{Mix.env()}.exs"
