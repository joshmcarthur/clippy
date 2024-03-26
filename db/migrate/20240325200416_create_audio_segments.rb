class CreateAudioSegments < ActiveRecord::Migration[7.1]
  def change
    create_table :audio_segments do |t|
      t.integer :sequence_number
      t.numeric :duration
      t.numrange :time
      t.belongs_to :upload, null: false, foreign_key: true
      t.json :raw, default: {}

      t.timestamps
    end

    add_index :audio_segments, %i[upload_id sequence_number], unique: true
  end
end
