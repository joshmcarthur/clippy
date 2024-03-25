OpenAI.configure do |config|
  config.access_token = Rails.application.credentials.openai.fetch(:access_token)
  config.organization_id = Rails.application.credentials.openai[:organization_id]
end
