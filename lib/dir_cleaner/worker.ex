defmodule DirCleaner.Worker do
  @moduledoc false
  use GenServer, restart: :temporary

  def start_link({_directory, _mode, _interval, _max_age} = arg) do
    GenServer.start_link(__MODULE__, arg)
  end

  def init({directory, mode, interval, max_age}) do
    state = %{
      directory: directory,
      mode: mode,
      interval: interval,
      max_age: max_age
    }

    {:ok, state}
  end
end
