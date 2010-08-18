require 'rubygems'
require 'redis'

CONSUMER = ENV['CONSUMER'] # a, b or c

REDIS = Redis.new

while(true) do
  sleep 1
  
  # take message from the queue
  id_and_message = REDIS.rpop CONSUMER

  next unless id_and_message
  
  # unique id and the payload
  empty, id, message = id_and_message.split(/^(\d+)\s(.*)$/)
  
  # Consume the message
  puts "#{id}: #{message}"

  # set response if not set, acknowledges the producer
  REDIS.setnx id, "Consumed by #{CONSUMER}"
  
end