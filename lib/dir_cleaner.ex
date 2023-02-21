defmodule DirCleaner do
  @external_resource readme = Path.expand("./README.md")
  @moduledoc readme
             |> File.read!()
             |> String.split("<!-- README START -->")
             |> Enum.fetch!(1)
end
