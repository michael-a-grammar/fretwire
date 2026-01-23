defmodule Fret.Note do
  @moduledoc false

  use Fret.Note.Elements

  alias Fret.Note.Elements

  @enforce_keys [:name, :accidental, :octave]

  defstruct [:name, :accidental, :octave, :frequency]

  @type t :: %__MODULE__{
          name: Elements.note_name(),
          accidental: Elements.accidental(),
          octave: Elements.octave(),
          frequency: Elements.frequency()
        }

  @type natural_note :: %__MODULE__{
          name: Elements.note_name(),
          accidental: :natural,
          octave: Elements.octave(),
          frequency: Elements.frequency()
        }

  @type sharp_note :: %__MODULE__{
          name: Elements.sharp_note_name(),
          accidental: :sharp,
          octave: Elements.octave(),
          frequency: Elements.frequency()
        }

  @type flat_note :: %__MODULE__{
          name: Elements.flat_note_name(),
          accidental: :flat,
          octave: Elements.octave(),
          frequency: Elements.frequency()
        }

  @type enharmonic_notes :: {sharp_note(), flat_note()}

  @type note :: natural_note() | enharmonic_notes()

  def new(sharp_note_name, flat_note_name, octave, frequency)
      when sharp_note_name in @sharp_note_names and
             flat_note_name in @flat_note_names do
    {
      new(sharp_note_name, :sharp, octave, frequency),
      new(flat_note_name, :flat, octave, frequency)
    }
  end

  def new(name, accidental, octave, frequency)
      when name in @note_names and
             accidental in @accidentals and
             octave in @octaves and
             is_float(frequency) do
    %__MODULE__{
      name: name,
      accidental: accidental,
      octave: octave,
      frequency: frequency
    }
  end

  def new(name, octave, frequency) do
    new(name, :natural, octave, frequency)
  end
end
