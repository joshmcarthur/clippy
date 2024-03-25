class CreateSegments < ActiveRecord::Migration[7.1]
  def change
    create_table :segments do |t|
      t.belongs_to :transcript, null: false, foreign_key: true
      t.numrange :range
      t.text :text
      t.json :raw

      t.timestamps
    end
  end
end
