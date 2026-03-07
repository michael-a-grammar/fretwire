defmodule Fretwire.Interval do
  @moduledoc false

  @interval_names [:unison, :second, :third, :fourth, :fifth, :sixth, :seventh, :octave]

  @perfect_interval_numbers [1, 4, 5, 8]

  @minor_and_major_interval_numbers [2, 3, 6, 7]

  @interval_numbers_to_semitones %{
    1 => 0,
    2 => 2,
    3 => 4,
    4 => 5,
    5 => 7,
    6 => 9,
    7 => 11,
    8 => 12
  }

  @enforce_keys [:quality, :name, :number, :semitones]

  defstruct [:quality, :name, :number, :semitones]

  @type quality :: :perfect | :minor | :major | :diminished | :augmented

  @type interval_name ::
          :unison | :second | :third | :fourth | :fifth | :sixth | :seventh | :octave

  @type perfect_interval_names :: :unison | :fourth | :fifth | :octave

  @type minor_and_major_interval_names :: :second | :third | :sixth | :seventh

  @type minor_interval_names :: minor_and_major_interval_names()

  @type major_interval_names :: minor_and_major_interval_names()

  @type interval_number :: 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8

  @type perfect_interval_numbers :: 1 | 4 | 5 | 8

  @type minor_and_major_interval_numbers :: 2 | 3 | 6 | 7

  @type minor_interval_numbers :: minor_and_major_interval_numbers()

  @type major_interval_numbers :: minor_and_major_interval_numbers()

  @type semitones :: 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12

  @type perfect_interval_semitones :: 0 | 5 | 7 | 12

  @type minor_and_major_interval_semitones :: 1 | 2 | 3 | 4 | 8 | 9 | 10 | 11

  @type minor_interval_semitones :: minor_and_major_interval_semitones()

  @type major_interval_semitones :: minor_and_major_interval_semitones()

  @type t :: %__MODULE__{
          quality: quality(),
          name: interval_name(),
          number: interval_number(),
          semitones: semitones()
        }

  @type perfect_interval :: %__MODULE__{
          quality: :perfect,
          name: perfect_interval_names(),
          number: perfect_interval_numbers(),
          semitones: perfect_interval_semitones()
        }

  @type minor_interval :: %__MODULE__{
          quality: :minor,
          name: minor_interval_names(),
          number: minor_interval_numbers(),
          semitones: minor_interval_semitones()
        }

  @type major_interval :: %__MODULE__{
          quality: :major,
          name: major_interval_names(),
          number: major_interval_numbers(),
          semitones: major_interval_semitones()
        }

  @spec new(:perfect, perfect_interval_numbers()) :: perfect_interval()
  @spec new(:minor | :major, minor_and_major_interval_numbers()) ::
          minor_interval() | major_interval()
  def new(:perfect, number) when number in @perfect_interval_numbers do
    create_interval(:perfect, number)
  end

  def new(quality, number)
      when quality in [:minor, :major] and number in @minor_and_major_interval_numbers do
    create_interval(quality, number)
  end

  defp create_interval(quality, number) do
    %__MODULE__{
      quality: quality,
      name: Enum.at(@interval_names, number - 1),
      number: number,
      semitones: calculate_semitones(quality, number)
    }
  end

  defp calculate_semitones(:minor, number) do
    calculate_semitones(number) - 1
  end

  defp calculate_semitones(_, number) do
    calculate_semitones(number)
  end

  defp calculate_semitones(number) do
    Map.fetch!(@interval_numbers_to_semitones, number)
  end
end
