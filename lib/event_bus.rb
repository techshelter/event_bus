# frozen_string_literal: true

require_relative "event_bus/version"
require_relative "event_bus/bus"

module EventBus
  class Error < StandardError; end
  class CannotRespondToEventError < StandardError; end
  class EventNotRegisteredError < StandardError; end
  class NotBlockGivenError < StandardError; end
  # Your code goes here...
  def self.new
    Bus.new
  end
end