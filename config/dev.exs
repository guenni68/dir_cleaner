import Config

config :dir_cleaner, DirCleaner,
  directories: ["/tmp/dir_cleaner"],
  interval: :timer.minutes(1),
  max_age: :timer.minutes(10)
