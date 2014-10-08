require 'cinch'
require 'yaml'

class BotManager

  # A Array with all bots in it.
  #
  # return[Array]
  attr_reader :bots

  # Load bots from config file and add a configuration to each according to
  # the config file.
  #
  # @return [void]
  def load_bots
    @bots = []

    config = load_config

    bot_name = config['bot']['name']

    # Iterates over every server on the config file
    config['bot']['servers'].each_value do |server|
      bot = Cinch::Bot.new do
        configure do |c|
          c.server = server['address']
          c.channels = server['channels']
          c.nick = bot_name
        end

        on :message, "hello" do |m|
          m.reply "Hello, #{m.user.nick}"
        end
      end

      @bots << bot
    end
  end

  # Starts all bots.
  #
  # @return [void]
  def start_bots
    @bots.each {|bot| bot.start}
  end

  private

  # Loads configuration file for bots
  #
  # @return [Hash] A hash containing all information in config/bots.yml
  def load_config
    YAML.load_file('../config/bots.yml')
  end

  # Loads keywords from the appropriate config file
  #
  # @return [Array] The array of keywords
  def keywords
    unless @keywords
      @keywords = YAML.load_file('../config/keywords.yml')['keywords']
    end

    @keywords
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

  # TODO: finish this
  def save_message
    nil
  end
end

# The program will start here
manager = BotManager.new
manager.load_bots
manager.start_bots
