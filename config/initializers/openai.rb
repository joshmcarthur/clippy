Rails.application.config.to_prepare do
  OpenAI.configure do |config|
    config.access_token = Rails.application.credentials.fetch(:openai, {}).fetch(:access_token, ENV["OPENAI_API_KEY"])
    config.organization_id = Rails.application.credentials.fetch(:openai, {}).fetch(:organization_id, ENV["OPENAI_ORGANIZATION_ID"])
  end
end
