##
# Performs a user-initiated search on the uploads table.
class UploadSearch
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
    entity_search = @scope.where("summaries.entities->>'name' = :term OR summaries.entities->>'entity' = :term", term:)
    @scope.joins(transcript: :summary)
      .where(id: Transcript.search(term).pluck(:upload_id))
      .or(entity_search)
  end
end
