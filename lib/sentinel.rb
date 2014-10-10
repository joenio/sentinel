 $LOAD_PATH << './lib'
require 'sentinel/bots_manager.rb'

module Sentinel

end

# The program will start here
manager = Sentinel::BotsManager.new
manager.load_bots
manager.start_bots
