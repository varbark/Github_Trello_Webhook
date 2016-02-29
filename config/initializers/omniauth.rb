Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['GITHUB_ID'], ENV['GITHUB_SECRET'], scope: "repo"
  provider :trello, ENV['TRELLO_APP_ID'], ENV['TRELLO_APP_SECRET'],
           app_name: "WebhookServer", scope: 'read,write', expiration: 'never'
end
