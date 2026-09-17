require "test_helper"

class NoteTest < ActiveSupport::TestCase
  test "title is required" do
    note = Note.new(title: "  ", body: "本文")
    assert_not note.valid?
    assert_includes note.errors[:title], "を入力してください"
  end

  test "search matches title and body and orders newest first" do
    assert_equal [notes(:one)], Note.search("Herb").to_a
    assert_equal [notes(:two)], Note.search("データベース").to_a
    assert_equal [notes(:two), notes(:one)], Note.search("").to_a
    assert_empty Note.search("見つからない")
  end

  test "LIKE wildcards and quotes are literal input" do
    percent = Note.create!(title: "100%", body: "")
    underscore = Note.create!(title: "snake_case", body: "")
    slash = Note.create!(title: "a\\b", body: "")
    assert_equal [percent], Note.search("%").to_a
    assert_equal [underscore], Note.search("_").to_a
    assert_equal [slash], Note.search("\\").to_a
    assert_empty Note.search("' OR 1=1 --")
  end
end
