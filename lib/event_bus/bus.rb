module EventBus
  class Bus
    def initialize
      @events = []
      @proc_handlers = {}
      @klass_handlers = []
    end

    def register(events_name)
      @events << events_name
      @proc_handlers[events_name] = []
    end

    def subscribe(handler)
      raise CannotRespondToEventError, handler.to_s unless can_respond?(handler)
      @klass_handlers << handler  
    end

    def on(event, &block)
      raise EventNotRegisteredError unless is_registered?(event)
      raise NotBlockGivenError unless block_given?
      @proc_handlers[event] << block
    end

    def publish(event, payload=nil)
      # priority to blocks
      execute_blocks_for_event(event, payload)
      execute_handlers_for_event(event, payload)
    end

    private
    def is_registered?(event_name)
      @events.include?(event_name)
    end

    def methods_from_event(event)
      underscore_event = event.gsub('.', '_')
      "on_#{underscore_event}"
    end

    def can_respond?(handler)
      resp = @events.any? do |event|
        handler.respond_to?(methods_from_event(event))
      end
    end

    def handlers_for_event(event)
      @klass_handlers.select do |klass|
        klass.respond_to?(methods_from_event(event))
      end
    end

    def execute_handlers_for_event(event, payload)
      handlers_for_event(event).each do |handler|
        handler.send(methods_from_event(event), payload)
      end
    end

    def execute_blocks_for_event(event, payload)
      if @proc_handlers.has_key?(event)
        @proc_handlers[event].each do |block|
          block.call(payload)
        end
      end
    end
  end
end