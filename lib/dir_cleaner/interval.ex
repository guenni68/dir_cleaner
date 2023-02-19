defmodule DirCleaner.Interval do
  @moduledoc false
  require Logger

  def start_interval(interval) do
    caller = self()
    Task.start_link(fn -> ping(interval, caller) end)
  end

  defp ping(interval, receiver) do
    send(receiver, :ping)
    Process.sleep(interval)
    ping(interval, receiver)
  end
end
