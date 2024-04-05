class CollateAudioSegmentsJob < SummariseJob
  queue_as :default

  self.prompt = <<~PROMPT
    Reformat this transcript, adding punctuation, paragraphs and spacing where necessary.
    The priority is for the transcript to be readable with paragraphs added where necessary.
    Do not add any spacing to the start or end of the transcript, because
    this is only one segment of the full transcript. Expect to the next message to be a JSON
    object containing two keys - previous and current. The previous key will contain the already-formatted
    text of the previous segment, and the current key will contain the raw text of the current segment to be formatted.
    If there is no previous segment, the previous key will be an empty string. This means that the raw text
    is the first segment of the transcript.
    Respond with the formatted text of the current segment only.
  PROMPT

  def perform(upload)
    transcript = Transcript.where(upload: upload, language: upload.language).first_or_create!(text: "")
    transcript.segments.destroy_all
    transcript.text = ""

    upload.audio_segments.each do |audio_segment|
      transcript.text << audio_segment.formatted || audio_segment.text

      audio_segment.raw.fetch("segments", []).each do |segment_data|
        starts = segment_data.fetch("start")
        ends = segment_data.fetch("end")
        text = segment_data.fetch("text")

        transcript.segments.where!(
          text: text,
          range: (audio_segment.time.begin + starts)..(audio_segment.time.begin + ends)
        ).first_or_create!(
          raw: segment_data
        )
      end
    end

    transcript.save!
  end
end
