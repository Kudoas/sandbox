module NotesHelper
  def search_notes(query)
    @search_results ||= {}
    @search_results[query] ||= Note.search(query).to_a
  end
end
