require 'sentinel/configuration'
require 'sentinel/irc_bot'
require 'sentinel/keywords_manager'
require 'sentinel/events'
require 'sentinel/adapter'

module Sentinel
  class BotsManager

    include Events

    # A Array with all bots in it.
    #
    # return[Array]
    attr_reader :irc_bots

    # Starts all bots.
    #
    # @return [void]
    def start_bots
      @irc_bots.each {|irc_bot| irc_bot.bot.start}
    end

    # Load bots from config file and add a configuration to each according to
    # the config file.
    #
    # @return [void]
    def load_bots
      @irc_bots = []

      config = Configuration.load_config_file

      bot_name = config['bot']['name']

      # Iterates over every server on the config file
      config['bot']['servers'].each_value do |server|
        irc_bot = Sentinel::IrcBot.new do
          configure do |c|
            c.server = server['address']
            c.channels = server['channels']
            c.nick = bot_name
          end

          on :message, KeywordsManager.keywords_regex do |m|
            #m.reply "Hello, #{m.user.nick}"
            Sentinel::AbstractAdapter.save_event(m, Sentinel::Events::MESSAGE)
          end
        end

        @irc_bots << irc_bot
      end
    end

    private

    # Returns true if a message contains one of the keywords
    #
    # @param [String] message a message from a IRC channel
    # @return [Boolean]
    def has_keyword?(message)
      KeywordsManager.keywords.each do |w|
        return true if message.include? w
      end

      false
    end
  end
end
