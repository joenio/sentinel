require 'sentinel/adapter'
require 'sentinel/configuration'
require 'sentinel/irc_bot'
require 'cinch'

module Sentinel
  class BotsManager

    include Events

    # A Array with all bots in it.
    #
    # return[Array]
    attr_reader :bots

    # Starts all bots.
    #
    # @return [void]
    def start_bots
      @bots.each {|bot| bot.bot.start}
    end

    # Load bots from config file and add a configuration to each according to
    # the config file.
    #
    # @return [void]
    def load_bots
      @bots = []

      config = Configuration.load_config_file

      bot_name = config['bot']['name']

      # Iterates over every server on the config file
      config['bot']['servers'].each_value do |server|
        bot = Cinch::Bot.new do
          configure do |c|
            c.server = server['address']
            c.channels = server['channels']
            c.nick = bot_name
            c.plugins.plugins = [IrcBot] # Sets the plugin as the IrcBot class
          end

          loggers << Sentinel::BotsManager.get_logger
        end
        @bots << bot
      end

      set_handlers
    end

    # Sets handlers for events such as messages, channel joins and leaves
    def set_handlers
      @bots.each do |bot|
        on_channel(bot)
        on_private(bot)
        on_join(bot)
        on_leaving(bot)
        on_topic(bot)
      end
    end

    def on_channel(bot)
      bot.on :channel, // do |e|
        Sentinel::AbstractAdapter.save_event(e, Sentinel::Events::MESSAGE)
      end
    end

    def on_private(bot)
      bot.on :private, // do |e|
        Sentinel::AbstractAdapter.save_event(e, Sentinel::Events::PRIVATE)
      end
    end

    def on_join(bot)
      bot.on :join, // do |e|
        Sentinel::AbstractAdapter.save_event(e, Sentinel::Events::JOIN)
      end
    end

    def on_leaving(bot)
      bot.on :leaving do |e|
        Sentinel::AbstractAdapter.save_event(e, Sentinel::Events::LEAVING)
      end
    end

    def on_topic(bot)
      bot.on :topic, // do |e|
        Sentinel::AbstractAdapter.save_event(e, Sentinel::Events::TOPIC)
      end
    end

    # Sets a logger for the bot
    def self.get_logger
      begin
        log = File.open('logs/log.log', 'a')
        logger = Cinch::Logger::FormattedLogger.new(log)
        logger.level = :log
        return logger
      rescue Errno::ENOENT
        FileUtils::mkdir_p 'logs'
        retry
      end
    end
  end
end
