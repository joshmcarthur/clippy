class AddAdditionalSummaryFields < ActiveRecord::Migration[7.1]
  def change
    add_column :summaries, :notes, :text
    add_column :summaries, :entities, :json, default: {}
  end
end
