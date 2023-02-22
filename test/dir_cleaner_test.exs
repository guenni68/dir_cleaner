defmodule DirCleanerTest do
  use ExUnit.Case

  test "verify config" do
    assert DirCleaner.Config.directories() == ["/tmp/dummy"]
    assert [%{start: {DirCleaner.Worker, _, _}}] = DirCleaner.Config.child_specs()
    assert DirCleaner.Config.max_age() == :timer.minutes(10)
    assert DirCleaner.Config.interval() == :timer.minutes(10)
    assert DirCleaner.Config.mode() == :touched
  end
end
