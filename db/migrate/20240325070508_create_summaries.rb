class CreateSummaries < ActiveRecord::Migration[7.1]
  def change
    create_table :summaries do |t|
      t.belongs_to :transcript, null: false, foreign_key: true
      t.text :text

      t.timestamps
    end
  end
end
