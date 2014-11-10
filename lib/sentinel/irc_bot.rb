require 'cinch'
require 'sentinel/events'
require 'sentinel/adapter'
require 'sentinel/keywords_manager'

module Sentinel
  class IrcBot

    include Cinch::Plugin

    set :prefix, //

    match KeywordsManager.keywords_regex, method: :save_message_with_keyword

    # Requests the adapter to save messages.
    #
    # @param [Message]
    # @return [void]
    def save_message_with_keyword(m)
      Sentinel::AbstractAdapter.save_message_with_keyword(m)
    end
  end
end
