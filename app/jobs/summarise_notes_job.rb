class SummariseNotesJob < SummariseJob
  queue_as :default
  self.prompt = <<~PROMPT.freeze
    You help users to quickly understand the key points of a meeting,
    including the attendees and any action points that are brought up.
    You are always given the transcript of a meeting. The next input will be the transcript.
    You should respond directly with the summary.
  PROMPT

  def perform(upload)
    transcript= upload.transcript
    summary = Summary.where(transcript: transcript).first_or_create!
    summary.update!(notes: summarise(transcript.text))
  end
end
