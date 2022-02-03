class ApplicationController < ActionController::API
    def produce_message
        topic_name = params.require(:topic_name)
        message = params.require(:message)
        formatted_topic_name = topic_name

        WaterDrop::SyncProducer.call(
            message,
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
