json.extract! upload, :id, :name, :created_at, :updated_at
json.url upload_url(upload, format: :json)
