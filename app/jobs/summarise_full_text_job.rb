class SummariseFullTextJob < SummariseJob
  queue_as :default
  self.prompt = <<~PROMPT.freeze
    Summarise the following meeting transcript in plain language.
  PROMPT


  def perform(upload)
    transcript = upload.transcript
    summary = Summary.where(transcript: transcript).first_or_create!
    summary.update!(text: summarise(transcript.text))
  end
end
