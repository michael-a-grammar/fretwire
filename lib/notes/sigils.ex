defmodule Fret.Notes.Sigils do
  @moduledoc false

  use Fret.Note.Elements

  def sigil_NOTE(string, []) do
    parse_accidental = fn accidental ->
      accidental
      |> String.downcase()
      |> case do
        "" ->
          :natural

        "#" ->
          :sharp

        "b" ->
          :flat
      end
      |> then(&{:ok, &1})
    end

    parse_name = fn name, accidental ->
      name
      |> String.downcase()
      |> then(fn name ->
        try do
          String.to_existing_atom(name)
        rescue
          _ in ArgumentError ->
            {:error, "can not parse name"}
        end
      end)
      |> then(fn name ->
        cond do
          accidental == :natural and name in @note_names ->
            {:ok, name}

          accidental == :sharp and name in @sharp_note_names ->
            {:ok, name}

          accidental == :flat and name in @flat_note_names ->
            {:ok, name}

          true ->
            {:error, "can not parse name"}
        end
      end)
    end

    parse_octave = fn octave ->
      octave
      |> Integer.parse()
      |> then(&{:ok, elem(&1, 0)})
    end

    with %{"name" => name, "accidental" => accidental, "octave" => octave} <-
           Regex.named_captures(
             ~r/^(?<name>[a-gA-G]{1,1})(?<accidental>#|b|)(?<octave>[0-8]{1,1})$/,
             string
           ),
         {:ok, accidental} <- parse_accidental.(accidental),
         {:ok, name} <- parse_name.(name, accidental),
         {:ok, octave} <- parse_octave.(octave) do
      %{
        name: name,
        accidental: accidental,
        octave: octave
      }
    else
      nil ->
        {:error, "can not parse note"}

      error ->
        error
    end
  end
end
