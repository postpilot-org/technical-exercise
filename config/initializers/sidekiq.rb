# frozen_string_literal: true

ENV['REDIS_URL'] ||= 'redis://localhost:6379'

# FYI: The network_timeout being set so high is just a safety pre-caution
# https://github.com/mperham/sidekiq/wiki/Using-Redis#life-in-the-cloud
Sidekiq.strict_args!(false)
Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'], network_timeout: 5 }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'], network_timeout: 5 }
end
