class SummariseEntitiesJob < SummariseJob
  queue_as :default
  self.prompt = <<~PROMPT.freeze
    Your role is to identify entities mentioned in the text.
    Entities can be people, organisations, or work programmes.
    If you see a name, a job title, or a project name, it is likely an entity.
    If the text indicates that someone is responsible for a task, that is also an entity.
    If the text suggests a person is present, identify that person as an attendee.
    You must respond with an array of entity names and types in JSON format.
    You must only respond with an array, not an object. The array must contain objects with a 'name' key and a 'type' key.
    The next input will be the transcript.
  PROMPT

  def perform(upload)
    transcript = upload.transcript
    summary = Summary.where(transcript: transcript).first_or_create!
    raw_response = summarise(transcript.text, response_format: { type: "json_object" })
    response = JSON.parse(raw_response)
    summary.update!(entities: response["entities"])
  end
end
