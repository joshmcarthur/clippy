class CreateClips < ActiveRecord::Migration[7.1]
  def change
    create_table :clips do |t|
      t.belongs_to :transcript, null: false, foreign_key: true
      t.float :start_time, null: false
      t.float :end_time, null: false

      t.timestamps
    end
  end
end
