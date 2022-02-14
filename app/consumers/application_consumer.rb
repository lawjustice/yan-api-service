
# frozen_string_literal: true
KarafkaBaseConsumer = Class.new(Karafka::BaseConsumer)

class ApplicationConsumer < KarafkaBaseConsumer
    def consume
        begin
            puts params.topic
            if params.payload["time_producer"].present?
                duration = Time.now - Time.parse(params.payload["time_producer"])
                message = "time to consume topic #{params.topic} with duration = #{duration}s"
                puts message
                Rails.logger.info(message)
            end
            return
        rescue Exception => e
            puts e
        end
    end
end