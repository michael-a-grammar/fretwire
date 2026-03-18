defmodule Fretwire.Notes.Query do
  @moduledoc false

  use Fretwire.Note.Elements

  alias Fretwire.Note.Elements
  alias Fretwire.Symbols

  @enforce_keys [:note_name, :accidental, :octave]

  defstruct [:note_name, :accidental, :octave]

  @type t :: %__MODULE__{
          note_name: Elements.note_name(),
          accidental: Symbols.accidental(),
          octave: Elements.octave()
        }

  defguard is_query(query)
           when is_map(query) and
                  query.note_name in @note_names and
                  query.accidental in @accidentals and
                  query.octave in @octaves
end
