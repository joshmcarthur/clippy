class CreateClips < ActiveRecord::Migration[7.1]
  def change
    create_table :clips do |t|
      t.belongs_to :transcript, null: false, foreign_key: true
      t.numrange :range, null: false

      t.timestamps
    end
  end
end
