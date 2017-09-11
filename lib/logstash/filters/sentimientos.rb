# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"
require "sentimental"

# This example filter will replace the contents of the default
# message field with whatever you specify in the configuration.
#
# It is only intended to be used as an example.
class LogStash::Filters::Sentimientos < LogStash::Filters::Base

  # Setting the config_name here is required. This is how you
  # configure this filter from your Logstash config.
  #
  # filter {
  #   example {
  #     message => "My message..."
  #   }
  # }
  #
  config_name "sentimientos"

  # Replace the message with this value.
  config :message, :validate => :string, :default => ""

  # What key to place sentiment values under
  config :target, :validate => :string, :default => 'sentimiento'


  public
  def register
    require 'sentimental'
    # Add instance variables
  end # def register

  public
  def filter(event)
    return unless filter?(event)

    nalyzer.load_defaults

    # And/or load your own dictionaries
    analyzer.load_senti_file('dict/en_words.json')

    if @message
      # Replace the event message with our message as configured in the
      # config file.

      # using the event.set API
      event.set("message", @message)
      # correct debugging log statement for reference
      # using the event.get API
      @logger.debug? && @logger.debug("Message is now: #{event.get("message")}")
    end

    # filter_matched should go in the last line of our successful code
    filter_matched(event)
  end # def filter
end # class LogStash::Filters::Example
