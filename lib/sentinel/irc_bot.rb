require 'cinch'

module Sentinel
  class IrcBot

    attr_reader :bot

    # Initializes a Cinch bot with the block received as argument
    def initialize(&b)
      @bot = Cinch::Bot.new(&b)
    end
  end
end
