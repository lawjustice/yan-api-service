# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'development'
ENV['KARAFKA_ENV'] = ENV['RAILS_ENV']
require ::File.expand_path('../config/environment', __FILE__)
Rails.application.eager_load!

class KafkaTopicMapper
  def initialize
    @prefix = "happyfresh_"
  end

  def incoming(topic)
    topic.to_s.gsub(@prefix, '')
  end

  def outgoing(topic)
    "#{@prefix}#{topic}"
  end
end

class KarafkaApp < Karafka::App
  setup do |config|
    kafka_urls = ENV["KAFKA_BROKERS"] || "127.0.0.1:9092"
    config.kafka.seed_brokers = ["kafka://#{kafka_urls}"]
    if ENV["CONFLUENT_USERNAME"].present?
      config.kafka.sasl_plain_username = ENV["CONFLUENT_USERNAME"]
      config.kafka.sasl_plain_password = ENV["CONFLUENT_PASSWORD"]
      config.kafka.ssl_ca_certs_from_system = true
    end

    config.topic_mapper = KafkaTopicMapper.new
    config.client_id = 'yan'
    config.backend = :inline
    config.batch_fetching = true

    config.logger.level = Logger::INFO
  end

  monitor.subscribe('app.initialized') do
    WaterDrop.setup { |config| config.deliver = !Karafka.env.test? }
  end

  Karafka.monitor.subscribe(WaterDrop::Instrumentation::StdoutListener.new)
  Karafka.monitor.subscribe(Karafka::Instrumentation::StdoutListener.new)
  Karafka.monitor.subscribe(Karafka::Instrumentation::ProctitleListener.new)

end

KarafkaApp.consumer_groups.draw do
  consumer_group :yan_group do
    topic :user do
      consumer ApplicationConsumer
    end
    topic :order do
      consumer ApplicationConsumer
    end
    topic :fulfillment do
      consumer ApplicationConsumer
    end
    topic :brands do
      consumer ApplicationConsumer
    end
    topic :taxons do
      consumer ApplicationConsumer
    end
    topic :taxonomies do
      consumer ApplicationConsumer
    end
    topic :product_types do
      consumer ApplicationConsumer
    end
    topic :products do
      consumer ApplicationConsumer
    end
    topic :store_products do
      consumer ApplicationConsumer
    end
    topic :rating do
      consumer ApplicationConsumer
    end
    topic :loyalty_profile do
      consumer ApplicationConsumer
    end
    topic :vendors do
      consumer ApplicationConsumer
    end
    topic :snd_categories do
      consumer ApplicationConsumer
    end
  end
end

KarafkaApp.boot!
