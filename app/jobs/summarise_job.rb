class SummariseJob < ActiveJob::Base
  class_attribute :prompt

  private

  def summarise(text, **parameters)
    client = OpenAI::Client.new
    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [
            { role: "system", content: self.class.prompt },
            { role: "user", content: text }
        ],
        **parameters
      }
    )

    response.fetch("choices").first.fetch("message").fetch("content")
  end
end
