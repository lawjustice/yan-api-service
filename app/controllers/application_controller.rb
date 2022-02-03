class ApplicationController < ActionController::API
    def produce_message
        topic_name = params.require(:topic_name)
        formatted_topic_name = topic_name
        message = {
            time_producer: Time.now
        }

        WaterDrop::SyncProducer.call(
            message.to_json,
            topic: format_topic_name(topic_name),
            partition_key: "#{message.size}"
        )
    end

    private

    def format_topic_name(name)
        prefix = "happyfresh_"
        "#{prefix}#{name}"
    end
end
