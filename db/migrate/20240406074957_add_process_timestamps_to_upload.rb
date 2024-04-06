class AddProcessTimestampsToUpload < ActiveRecord::Migration[7.1]
  def change
    add_column :uploads, :processing_started_at, :datetime
    add_column :uploads, :processing_ended_at, :datetime
  end
end
