defmodule DirCleaner.Worker do
  @moduledoc false
  use GenServer, restart: :temporary
  alias DirCleaner.Interval
  require Logger

  def start_link({_directory, _mode, _interval, _max_age} = arg) do
    GenServer.start_link(__MODULE__, arg)
  end

  @impl GenServer
  def init({directory, mode, interval, max_age}) do
    Interval.start_interval(interval)

    state = %{
      directory: directory,
      mode: mode,
      max_age: max_age
    }

    {:ok, state}
  end

  @impl GenServer
  def handle_info(:ping, %{directory: directory, mode: mode, max_age: max_age} = state) do
    Logger.debug("ping received")
    {:noreply, state}
  end
end
