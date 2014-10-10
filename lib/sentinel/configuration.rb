require 'yaml'

module Configuration

  # Loads configuration file for bots
  #
  # @return [Hash] A hash containing all information in config/bots.yml
  def self.load_config_file
    YAML.load_file('config/bots.yml')
  end
end
