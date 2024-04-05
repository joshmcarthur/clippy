class AddTextAndFormattedTextToAudioSegments < ActiveRecord::Migration[7.1]
  def change
    add_column :audio_segments, :text, :text
    add_column :audio_segments, :formatted, :text
  end
end
