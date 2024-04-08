##
# Performs a user-initiated search on the uploads table.
class UploadSearch
  # MVP: Search in transcription full text,
  # TODO: exact matches on entity name (and optional description)
  # TODO: Support multiple languages. We have the ISO code, we'd need to find the right dictionary.
  # TODO: Vector search on embeddings
  SEARCH = <<~SQL.squish.freeze
    SELECT DISTINCT uploads.*, ts_rank(to_tsvector('english', transcripts.text), websearch_to_tsquery('english', :term)) AS rank
    FROM uploads
    INNER JOIN transcripts ON transcripts.upload_id = uploads.id
    INNER JOIN summaries ON transcripts.id = summaries.transcript_id
    WHERE to_tsvector('english', transcripts.text) @@ websearch_to_tsquery('english', :term)
    OR summaries.entities->>'name' = :term
    OR summaries.entities->>'entity' = :term
    ORDER BY rank DESC
  SQL

  attr_reader :term

  def initialize(term:, scope: Upload.all)
    @term = term
    @scope = scope
  end

  def results
    execute unless @executed

    @results
  end

  def execute
    @executed = true
    @results = execute_query
  end

  private

  def execute_query
    @scope.find_by_sql([SEARCH, { term: term }])
  end
end
