class CreateClips < ActiveRecord::Migration[7.1]
  def change
    create_table :clips do |t|
      t.belongs_to :start_segment, null: false, foreign_key: { to_table: :segments }
      t.belongs_to :end_segment, null: false, foreign_key: { to_table: :segments }

      t.timestamps
    end
  end
end
