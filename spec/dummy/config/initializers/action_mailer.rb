Dummy::Application.configure do
  config.action_mailer.default_url_options = { host: '*.lvh.me:7171' }
  ActionMailer::Base.default from: 'support@example.com'
end
