defmodule Fretwire.Fret do
  @moduledoc false

  alias Fretwire.Note

  @enforce_keys [:number, :note]

  defstruct [:number, :note]

  @type t :: %__MODULE__{
          number: pos_integer(),
          note: Note.note()
        }
end
