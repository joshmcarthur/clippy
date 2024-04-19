class AddProcessingStageToUploads < ActiveRecord::Migration[7.1]
  def change
    add_column :uploads, :processing_stage, :string, default: 'pending', null: false
  end
end
