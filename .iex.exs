import_file_if_available("~/.iex.exs")

import Fretwire.Interval.Sigils
import Fretwire.Notes.Sigils

alias Fretwire.Interval
alias Fretwire.Note
alias Fretwire.Notes

defmodule Helpers do
  def fretboard() do
    [
      notes_from(~NOTE/E4/),
      notes_from(~NOTE/B3/),
      notes_from(~NOTE/G3/),
      notes_from(~NOTE/D3/),
      notes_from(~NOTE/A2/),
      notes_from(~NOTE/E2/)
    ]
  end

  defp notes_from(note) do
    note
    |> Notes.from(12)
    |> Enum.map(fn
      %Note{name: name} ->
        to_string(name)

      {%Note{name: name}, _} ->
        "#{name}#"
    end)
  end
end
