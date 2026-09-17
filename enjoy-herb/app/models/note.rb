class Note < ApplicationRecord
  validates :title, presence: true

  def self.search(query)
    term = query.to_s.strip
    notes = order(updated_at: :desc, id: :desc)
    return notes if term.empty?

    pattern = "%#{sanitize_sql_like(term)}%"
    notes.where("title LIKE :query ESCAPE '\\' OR body LIKE :query ESCAPE '\\'", query: pattern)
  end
end
