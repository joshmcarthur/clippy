class CreateUploads < ActiveRecord::Migration[7.1]
  def change
    create_table :uploads do |t|
      t.string :name

      t.timestamps
    end
  end
end
