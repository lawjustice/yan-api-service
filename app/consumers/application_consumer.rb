
# frozen_string_literal: true
KarafkaBaseConsumer = Class.new(Karafka::BaseConsumer)

class ApplicationConsumer < KarafkaBaseConsumer
    def consume
        begin
            puts params
            return
        rescue Exception => e
            Raven.capture_exception(e)
        end
    end
end