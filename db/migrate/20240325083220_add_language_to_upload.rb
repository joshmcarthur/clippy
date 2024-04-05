class AddLanguageToUpload < ActiveRecord::Migration[7.1]
  def up
    add_column :uploads, :language, :string, limit: 5

    Upload.find_each do |upload|
      upload.send(:default_language)
      upload.save!
    end

    change_column_null :uploads, :language, false
  end

  def down
    remove_column :uploads, :language, :string, limit: 5
  end
end
