# DirCleaner

<!-- README START -->
**DirCleaner is a simple-to-use utility to automatically remove stale or temporary files from specified directories**

## Usage

in order to use DirCleaner put the following into your config.exs:

```elixir
config :dir_cleaner, DirCleaner,
  # set the paths of the directories where you want stale files removed,
  # defaults to []
  directories: ["/tmp/dir1", "/tmp/dir2"],

  # optional - sets the interval on how often dir_cleaner looks
  # for files older than max_age and removes them.
  # defaults to 10 minutes
  # value has to be given in milliseconds
  interval: :timer.minutes(5),

  # optional - sets the max age value of the files,
  # defaults to 10 minutes
  # value has to be given in milliseconds
  max_age: :timer.minutes(5)
```

These values are used at **compile time**. That means that if you change these values
and recompile mix will complain during (re)compilation.

You can overcome the mix compile warning by issuing

```bash
mix deps.compile dir_cleaner --force
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `dir_cleaner` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:dir_cleaner, "~> 0.1.0"}
  ]
end
```
