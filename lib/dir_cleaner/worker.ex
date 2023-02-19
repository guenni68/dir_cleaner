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
    Logger.debug("cleanup started for #{directory}")
    clean_directory(directory, mode, max_age)
    {:noreply, state}
  end

  def clean_directory(directory, mode, max_age) do
    threshold =
      NaiveDateTime.local_now()
      |> NaiveDateTime.add(max_age * -1, :millisecond)

    with true <- File.dir?(directory),
         {:ok, filenames} <- File.ls(directory) do
      filenames
      |> Enum.map(fn filename -> Path.join([directory, filename]) end)
      |> Enum.flat_map(fn path ->
        case File.stat(path) do
          {:ok, %{type: :regular} = stat} ->
            check_file(path, threshold, stat, mode)

          _ ->
            []
        end
      end)
      |> Enum.each(fn path -> File.rm(path) end)
    end
  end

  defp check_file(path, threshold, %{atime: time}, :touched) do
    atime = naive_date_time_from_tuple(time)

    if NaiveDateTime.compare(atime, threshold) == :lt do
      [path]
    else
      []
    end
  end

  defp check_file(path, threshold, %{ctime: time}, :created) do
    ctime = naive_date_time_from_tuple(time)

    if NaiveDateTime.compare(ctime, threshold) == :lt do
      [path]
    else
      []
    end
  end

  defp check_file(_path, _threshold, _stat, _mode) do
    Logger.warn("configuration error in mode")
    []
  end

  defp naive_date_time_from_tuple({{year, day, month}, {hour, minute, second}}) do
    NaiveDateTime.new!(year, day, month, hour, minute, second)
  end
end
