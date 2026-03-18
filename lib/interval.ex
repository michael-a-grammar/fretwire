defmodule Fretwire.Interval do
  @moduledoc false

  @interval_names [:unison, :second, :third, :fourth, :fifth, :sixth, :seventh, :octave]

  @perfect_interval_numbers [1, 4, 5, 8]

  @minor_and_major_interval_numbers [2, 3, 6, 7]

  @diminished_interval_numbers [2, 3, 4, 5, 6, 7, 8]

  @augmented_interval_numbers [1, 2, 3, 4, 5, 6, 7]

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

  @type perfect_interval_name :: :unison | :fourth | :fifth | :octave

  @type minor_and_major_interval_name :: :second | :third | :sixth | :seventh

  @type minor_interval_name :: minor_and_major_interval_name()

  @type major_interval_name :: minor_and_major_interval_name()

  @type diminished_interval_name ::
          :second | :third | :fourth | :fifth | :sixth | :seventh | :octave

  @type augmented_interval_name ::
          :unison | :second | :third | :fourth | :fifth | :sixth | :seventh

  @type interval_number :: 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8

  @type perfect_interval_number :: 1 | 4 | 5 | 8

  @type minor_and_major_interval_number :: 2 | 3 | 6 | 7

  @type minor_interval_number :: minor_and_major_interval_number()

  @type major_interval_number :: minor_and_major_interval_number()

  @type diminished_interval_number :: 2 | 3 | 4 | 5 | 6 | 7 | 8

  @type augmented_interval_number :: 1 | 2 | 3 | 4 | 5 | 6 | 7

  @type semitone :: 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12

  @type perfect_interval_semitone :: 0 | 5 | 7 | 12

  @type minor_and_major_interval_semitone :: 1 | 2 | 3 | 4 | 8 | 9 | 10 | 11

  @type minor_interval_semitone :: minor_and_major_interval_semitone()

  @type major_interval_semitone :: minor_and_major_interval_semitone()

  @type diminished_interval_semitone :: 0 | 2 | 4 | 6 | 7 | 9 | 11

  @type augmented_interval_semitone :: 1 | 3 | 5 | 6 | 8 | 10 | 12

  @type t :: %__MODULE__{
          quality: quality(),
          name: interval_name(),
          number: interval_number(),
          semitones: semitone()
        }

  @type perfect_interval :: %__MODULE__{
          quality: :perfect,
          name: perfect_interval_name(),
          number: perfect_interval_number(),
          semitones: perfect_interval_semitone()
        }

  @type minor_interval :: %__MODULE__{
          quality: :minor,
          name: minor_interval_name(),
          number: minor_interval_number(),
          semitones: minor_interval_semitone()
        }

  @type major_interval :: %__MODULE__{
          quality: :major,
          name: major_interval_name(),
          number: major_interval_number(),
          semitones: major_interval_semitone()
        }

  @type diminished_interval :: %__MODULE__{
          quality: :diminished,
          name: diminished_interval_name(),
          number: diminished_interval_number(),
          semitones: diminished_interval_semitone()
        }

  @type augmented_interval :: %__MODULE__{
          quality: :augmented,
          name: augmented_interval_name(),
          number: augmented_interval_number(),
          semitones: augmented_interval_semitone()
        }

  @spec new(:perfect, perfect_interval_number()) :: perfect_interval()
  @spec new(:minor | :major, minor_and_major_interval_number()) ::
          minor_interval() | major_interval()
  @spec new(:diminished, diminished_interval_number()) :: diminished_interval()
  @spec new(:augmented, augmented_interval_number()) :: augmented_interval()
  def new(:perfect = quality, number) when number in @perfect_interval_numbers do
    create_interval(quality, number)
  end

  def new(quality, number)
      when quality in [:minor, :major] and number in @minor_and_major_interval_numbers do
    create_interval(quality, number)
  end

  def new(:diminished = quality, number) when number in @diminished_interval_numbers do
    create_interval(quality, number)
  end

  def new(:augmented = quality, number) when number in @augmented_interval_numbers do
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

  defp calculate_semitones(:diminished, number) when number in @perfect_interval_numbers do
    calculate_semitones(number) - 1
  end

  defp calculate_semitones(:diminished, number) do
    calculate_semitones(:minor, number) - 1
  end

  defp calculate_semitones(:augmented, number) do
    calculate_semitones(:major, number) + 1
  end

  defp calculate_semitones(:major, number) do
    calculate_semitones(number)
  end

  defp calculate_semitones(number) do
    @interval_numbers_to_semitones[number]
  end
end
