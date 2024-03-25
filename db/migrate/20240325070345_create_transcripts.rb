class CreateTranscripts < ActiveRecord::Migration[7.1]
  def change
    create_table :transcripts do |t|
      t.belongs_to :upload, null: false, foreign_key: true
      t.string :language, limit: 5
      t.text :text
      t.json :raw


      t.timestamps
    end
  end
end
