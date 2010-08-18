require 'rubygems'
require 'sinatra'
require 'redis'

before do
  @redis = Redis.new
end


post '/' do
  message = params[:message]
  
  id = @redis.incr "id"

  # Send to three queues
  @redis.multi do
    @redis.lpush "a", "#{id} #{message}"
    @redis.lpush "b", "#{id} #{message}"
    @redis.lpush "c", "#{id} #{message}"
  end
  
  # Wait for the first response
  until @redis.exists(id) do
  end

  @redis.get(id) + "\n"
end