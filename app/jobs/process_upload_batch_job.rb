class ProcessUploadBatchJob < ApplicationJob
  queue_as :default

  ## Transitions an upload through a full extraction process
  # Extract audio, then transcribe, then extract the full transcription text,
  # then summarise using the full transcription text, then extract the segments.
  # Audio extraction has to be done first, then transcription, but the last three
  # steps can be done in parallel
  def perform(batch, _params)
    upload = batch.properties.fetch(:upload)

    case batch.properties[:step]
    when :start
      upload.update!(processing_started_at: Time.zone.now)
      batch.enqueue(step: :extract_audio) do
        ExtractAudioJob.perform_later(upload)
      end
    when :extract_audio
      batch.enqueue(step: :collate) do
        upload.audio_segments.each do |segment|
          TranscribeAudioSegmentJob.perform_later(segment)
        end
      end
    when :collate
      batch.enqueue(step: :extract) do
        CollateAudioSegmentsJob.perform_later(upload)
      end
    when :extract
      batch.enqueue(step: :summarise) do
        SummariseFullTextJob.perform_later(upload)
        SummariseEntitiesJob.perform_later(upload)
        SummariseNotesJob.perform_later(upload)
      end
    when :summarise
      upload.update!(processing_ended_at: Time.zone.now)
    end
  end
end
