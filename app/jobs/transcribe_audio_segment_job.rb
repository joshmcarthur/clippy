class TranscribeAudioSegmentJob < SummariseJob
  queue_as :default

  self.prompt = <<~PROMPT
    Reformat this transcript, adding punctuation, paragraphs and spacing where necessary.
    The priority is for the transcript to be readable with paragraphs added where necessary.
    Do not add any spacing to the start or end of the transcript, because
    this is only one segment of the full transcript.
    Respond with the formatted text only.
  PROMPT

  def perform(audio_segment)
    previous_segment = audio_segment.upload.audio_segments.find_by(
      sequence_number: [audio_segment.sequence_number - 1, 0].max)
    upload = audio_segment.upload
    client = OpenAI::Client.new

    audio_segment.audio.open do |audio_file|
      transcription = client.audio.transcribe(
        parameters: {
          model: "whisper-1",
          language: upload.language_iso639_1,
          timestamp_granularities: ["segment"],
          prompt: previous_segment&.raw&.fetch("text", ""),
          response_format: "verbose_json",
          file: audio_file
        }
      )

      text = transcription.fetch("text")
      formatted = summarise(text)

      audio_segment.update!(raw: transcription, text: text, formatted: formatted)
    end
  end
end
