require 'cinch'

module Sentinel
  class IrcBot

    attr_reader :bot

    # Initializes a Cinch bot with the block received as argument
    def initialize(&b)
      @bot = Cinch::Bot.new(&b)
      @bot.loggers << new_logger
    end

    protected

    # Sets a logger for the bot
    def new_logger
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
