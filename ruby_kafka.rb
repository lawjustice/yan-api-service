# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("./lib", __FILE__))

require "kafka"
require 'json'
require 'time'
require 'dotenv'


logger = Logger.new(STDOUT)
Dotenv.load

brokers = ENV.fetch("KAFKA_BROKERS", "localhost:9092").split(",")
# Make sure to create this topic in your Kafka cluster or configure the
# cluster to auto-create topics.
# topic = "happyfresh_user"

if ENV.fetch('KAFKA_PROVIDER') == 'confluent'
  kafka = Kafka.new(
    seed_brokers: brokers,
    sasl_plain_username: ENV.fetch("CONFLUENT_USERNAME"),
    sasl_plain_password: ENV.fetch("CONFLUENT_PASSWORD"),
    ssl_ca_certs_from_system: true,
    client_id: "test-yan",
    socket_timeout: 20,
    logger: logger,
  )
else
  kafka = Kafka.new(
    seed_brokers: brokers,
    client_id: "test-yan",
    socket_timeout: 20,
    logger: logger,
  )
end



consumer = kafka.consumer(group_id: "test-yan")
consumer.subscribe('happyfresh_user', start_from_beginning: false)
consumer.subscribe('happyfresh_order', start_from_beginning: false)
consumer.subscribe('happyfresh_fulfillment', start_from_beginning: false)
consumer.subscribe('happyfresh_brands', start_from_beginning: false)
consumer.subscribe('happyfresh_taxons', start_from_beginning: false)
consumer.subscribe('happyfresh_taxonomies', start_from_beginning: false)
consumer.subscribe('happyfresh_order', start_from_beginning: false)
consumer.subscribe('happyfresh_product_types', start_from_beginning: false)
consumer.subscribe('happyfresh_products', start_from_beginning: false)
consumer.subscribe('happyfresh_store_products', start_from_beginning: false)
consumer.subscribe('happyfresh_rating', start_from_beginning: false)
consumer.subscribe('happyfresh_loyalty_profile', start_from_beginning: false)
consumer.subscribe('happyfresh_vendors', start_from_beginning: false)
consumer.subscribe('happyfresh_snd_categories', start_from_beginning: false)

trap("TERM") { consumer.stop }
trap("INT") { consumer.stop }

begin
  consumer.each_message do |message|
    begin
        puts message.topic
        puts "duration_create_time = "
        event = JSON.parse(message.value)
        puts event
        puts "#{event["time_producer"]}s"
        time_producer = event["time_producer"]
        if !time_producer.nil?
            duration = Time.now - Time.parse(time_producer)
            puts "duration = #{duration}s"
        end
    rescue Exception => e
      puts e
      next
    end
  end
rescue Kafka::ProcessingError => e
  warn "Got #{e.cause}"
  consumer.pause(e.topic, e.partition, timeout: 20)

  retry
end