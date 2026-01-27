defmodule Fretwire.Fretboard do
  @moduledoc false

  alias Fretwire.Fret

  @enforce_keys [:frets]

  defstruct [:frets]

  @type t :: %__MODULE__{
          frets: nonempty_list(Fret.t())
        }
end
