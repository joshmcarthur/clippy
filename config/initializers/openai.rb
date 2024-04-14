OpenAI.configure do |config|
  config.access_token = Rails.application.credentials.openai.fetch(:access_token, ENV["OPENAI_API_KEY"])
  config.organization_id = Rails.application.credentials.openai[:organization_id] || ENV["OPENAI_ORGANIZATION_ID"]
end
