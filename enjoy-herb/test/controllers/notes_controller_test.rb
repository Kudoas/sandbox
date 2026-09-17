require "test_helper"

class NotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @note = notes(:one)
  end

  test "should get index" do
    get notes_url
    assert_response :success
    assert_select "#query"
    assert_select "#note-results a", text: @note.title
    assert_select "#note-results .empty[data-empty='false']", count: 1
    assert_select "template[data-herb-manifests]" do |elements|
      manifest = JSON.parse(elements.first.text)
      states = manifest.values.map { |entry| entry.fetch("states") }
      assert states.any? { |state| state.fetch("fragments", {}).any? }
      assert states.any? { |state| state.dig("server", "reads", "query").present? }
    end
  end

  test "should get new" do
    get new_note_url
    assert_response :success
  end

  test "should create note" do
    assert_difference("Note.count") do
      post notes_url, params: { note: { body: @note.body, title: @note.title } }
    end

    assert_redirected_to note_url(Note.last)
  end

  test "should show note" do
    get note_url(@note)
    assert_response :success
  end

  test "should get edit" do
    get edit_note_url(@note)
    assert_response :success
  end

  test "should update note" do
    patch note_url(@note), params: { note: { body: "変更した本文", title: "変更したタイトル" } }
    assert_redirected_to note_url(@note)
    assert_equal "変更したタイトル", @note.reload.title
    assert_equal "変更した本文", @note.body
  end

  test "invalid create renders errors without saving" do
    assert_no_difference("Note.count") do
      post notes_url, params: { note: { title: "", body: "本文" } }
    end
    assert_response :unprocessable_content
    assert_select "[role=alert]", text: /タイトルを入力してください/
  end

  test "invalid update preserves the saved note" do
    old_title = @note.title
    patch note_url(@note), params: { note: { title: "", body: "本文" } }
    assert_response :unprocessable_content
    assert_equal old_title, @note.reload.title
  end

  test "slots request uses declared query to return filtered results" do
    get notes_url
    manifest = JSON.parse(css_select("template[data-herb-manifests]").first.text)
    file = manifest.values.find { |entry| entry.dig("states", "server", "reads", "query").present? }.fetch("file")

    get notes_url, headers: {
      "Accept" => "application/vnd.herb.slots+json",
      "Herb-State" => { file => { query: "Herb" } }.to_json
    }
    assert_response :success
    assert_equal "application/vnd.herb.slots+json", response.media_type
    payload = JSON.parse(response.body)
    assert payload.key?("slots")
    assert_includes response.body, @note.title
    assert_not_includes response.body, notes(:two).title
    assert_equal "no-store", response.headers["Cache-Control"]
  end

  test "empty search renders an explanatory message" do
    get notes_url
    assert_includes response.body, "メモが見つかりません。"
    manifest = JSON.parse(css_select("template[data-herb-manifests]").first.text)
    file = manifest.values.find { |entry| entry.dig("states", "server", "reads", "query").present? }.fetch("file")

    get notes_url, headers: {
      "Accept" => "application/vnd.herb.slots+json",
      "Herb-State" => { file => { query: "見つからない" } }.to_json
    }

    assert_response :success
    assert_includes response.body, '"true"'
  end

  test "should destroy note" do
    assert_difference("Note.count", -1) do
      delete note_url(@note)
    end

    assert_redirected_to notes_url
  end
end
