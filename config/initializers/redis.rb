require 'redis'

redis_url = ENV.fetch('REDIS_URL', 'redis://localhost:6379/1')
$redis = Redis.new(url: redis_url)

# Allow accessing the Redis instance through Redis.current for legacy code
Redis.current = $redis 