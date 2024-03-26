class TranscribeAudioSegmentJob < ApplicationJob
  queue_as :default

  def perform(audio_segment)
    upload = audio_segment.upload
    client = OpenAI::Client.new

    audio_segment.audio.open do |audio_file|
      transcription = client.audio.transcribe(
        parameters: {
          model: "whisper-1",
          language: upload.language_iso639_1,
          timestamp_granularities: ["segment"],
          response_format: "verbose_json",
          file: audio_file
        }
      )

      audio_segment.update!(raw: transcription)
    end
  end
end
