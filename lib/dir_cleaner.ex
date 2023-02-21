defmodule DirCleaner do
  @external_resource readme = Path.expand("./README.md")
  @moduledoc readme
             |> File.read!()
             |> String.split("<!-- README START -->")
             |> Enum.fetch!(1)

  config = Application.compile_env(:dir_cleaner, __MODULE__, [])
  config_directories = Keyword.get(config, :directories, [])
  config_mode = Keyword.get(config, :mode, :touched)
  config_interval = Keyword.get(config, :interval, :timer.minutes(10))
  config_max_age = Keyword.get(config, :max_age, :timer.minutes(10))

  config_child_specs =
    for {dir, index} <- Enum.with_index(config_directories, 1) do
      Supervisor.child_spec(
        {DirCleaner.Worker, {dir, config_mode, config_interval, config_max_age}},
        id: :"#{DirCleaner.Worker}-#{index}"
      )
    end

  @doc false
  def child_specs() do
    unquote(config_child_specs |> Macro.escape())
  end

  @doc false
  def directories() do
    unquote(config_directories)
  end

  @doc false
  def mode() do
    unquote(config_mode)
  end

  @doc false
  def interval() do
    unquote(config_interval)
  end

  @doc false
  def max_age() do
    unquote(config_max_age)
  end
end
