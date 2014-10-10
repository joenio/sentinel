require 'sentinel/configuration'
require 'sentinel/irc_bot'

module Sentinel
  class BotsManager

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

          on :message, "hello" do |m|
            m.reply "Hello, #{m.user.nick}"
          end
        end

        @irc_bots << irc_bot
      end
    end

    private

    # Loads keywords from the appropriate config file
    #
    # @return [Array] The array of keywords
    def keywords
      unless @keywords
        @keywords = YAML.load_file('../config/keywords.yml')['keywords']
      end

      @keywords
    end

    # Returns the keywords on a regex format ready to used for matching incoming
    # messages.
    def keyword_regex
      string = ""

      keywords.each do |keyword|
        string << "(#{keyword})|"
      end
    end

    # Returns true if a message contains one of the keywords
    #
    # @param [String] message a message from a IRC channel
    # @return [Boolean]
    def has_keyword?(message)
      @keywords.each do |w|
        return true if message.include? w
      end

      false
    end
  end
end
