
# frozen_string_literal: true
KarafkaBaseConsumer = Class.new(Karafka::BaseConsumer)

class ApplicationConsumer < KarafkaBaseConsumer
    def consume
        begin
            puts params.topic
            duration_create_time = Time.now - params.metadata.create_time
            puts "duration_create_time = #{duration_create_time}s"
            if params.payload["time_producer"].present?
                duration = Time.now - params.payload["time_producer"]
                puts "duration = #{duration}s"
            end
            return
        rescue Exception => e
            Raven.capture_exception(e)
        end
    end
end