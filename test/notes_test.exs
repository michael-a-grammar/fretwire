defmodule Fretwire.NotesTest do
  use ExUnit.Case, async: true

  alias Fretwire.Note
  alias Fretwire.Notes
  alias Fretwire.Notes.Query

  describe "find/1" do
    test "should return a `t:Fretwire.Note.natural_note/0` for the given _natural note_ `t:Fretwire.Notes.Query.t/0` query" do
      %Note{
        name: :e,
        accidental: :natural,
        octave: 2,
        frequency: _
      } =
        Notes.find(%Query{
          note_name: :e,
          accidental: :natural,
          octave: 2
        })
    end

    test "shoud return a `t:Fretwire.Note.enharmonic_note/0` for the given _sharp note_ `t:Fretwire.Notes.Query.t/0` query" do
      {%Note{
         name: :f,
         accidental: :sharp,
         octave: 2,
         frequency: _
       },
       %Note{
         name: :g,
         accidental: :flat,
         octave: 2,
         frequency: _
       }} =
        Notes.find(%Query{
          note_name: :f,
          accidental: :sharp,
          octave: 2
        })
    end

    test "shoud return a `t:Fretwire.Note.enharmonic_note/0` for the given _flat note_ `t:Fretwire.Notes.Query.t/0` query" do
      {%Note{
         name: :f,
         accidental: :sharp,
         octave: 2,
         frequency: _
       },
       %Note{
         name: :g,
         accidental: :flat,
         octave: 2,
         frequency: _
       }} =
        Notes.find(%Query{
          note_name: :g,
          accidental: :flat,
          octave: 2
        })
    end

    test "should raise a `FunctionClauseError` for the given `t:Fretwire.Notes.Query.t/0` query with an unknown note" do
      assert_raise FunctionClauseError, fn ->
        Notes.find(%Query{
          note_name: :unknown,
          accidental: :natural,
          octave: 2
        })
      end
    end

    test "should raise a `FunctionClauseError` for the given `t:Fretwire.Notes.Query.t/0` query with an unknown accidental" do
      assert_raise FunctionClauseError, fn ->
        Notes.find(%Query{
          note_name: :e,
          accidental: :unknown,
          octave: 2
        })
      end
    end

    test "should raise a `FunctionClauseError` for the given `t:Fretwire.Notes.Query.t/0` query with an unknown octave" do
      assert_raise FunctionClauseError, fn ->
        Notes.find(%Query{
          note_name: :h,
          accidental: :natural,
          octave: 9
        })
      end
    end
  end
end
