require 'cinch'
require 'yaml'

class BotManager

  # Collection of bots
  attr_reader :bots

  # Load bots from config file
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

  def start_bots
    @bots.each {|bot| bot.start}
  end

  private

  def load_config
    YAML.load_file('../config/bots.yml')
  end
end

manager = BotManager.new
manager.load_bots
manager.start_bots
