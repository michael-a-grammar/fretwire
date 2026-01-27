defmodule Fretwire.Note.Guards do
  @moduledoc false

  use Fretwire.Note.Elements

  alias Fretwire.Note

  defguard is_natural_note(note)
           when is_struct(note, Note) and
                  note.name in @natural_note_names and
                  note.accidental == :natural and
                  note.octave in @octaves

  defguard is_sharp_note(note)
           when is_struct(note, Note) and
                  note.name in @sharp_note_names and
                  note.accidental == :sharp and
                  note.octave in @octaves

  defguard is_flat_note(note)
           when is_struct(note, Note) and
                  note.name in @flat_note_names and
                  note.accidental == :flat and
                  note.octave in @octaves

  defguard is_enharmonic_note(note)
           when is_tuple(note) and
                  note
                  |> elem(0)
                  |> is_sharp_note() and
                  note
                  |> elem(1)
                  |> is_flat_note()

  defguard is_note(note)
           when is_natural_note(note) or
                  is_sharp_note(note) or
                  is_flat_note(note) or
                  is_enharmonic_note(note)
end
