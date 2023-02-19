defmodule DirCleaner do
  config = Application.compile_env(:dir_cleaner, __MODULE__, [])
  config_directories = Keyword.get(config, :directories, [])
  config_mode = Keyword.get(config, :mode, :touched)
  config_interval = Keyword.get(config, :interval, :timer.minutes(10))
  config_max_age = Keyword.get(config, :max_age, :timer.minutes(20))

  config_child_specs =
    for {dir, index} <- Enum.with_index(config_directories, 1) do
      Supervisor.child_spec(
        {DirCleaner.Worker, {dir, config_mode, config_interval, config_max_age}},
        id: :"#{DirCleaner.Worker}-#{index}"
      )
    end

  def child_specs() do
    unquote(config_child_specs |> Macro.escape())
  end

  def directories() do
    unquote(config_directories)
  end

  def mode() do
    unquote(config_mode)
  end

  def interval() do
    unquote(config_interval)
  end

  def max_age() do
    unquote(config_max_age)
  end
end
