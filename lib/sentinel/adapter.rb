require 'sentinel/adapter/csv_adapter'
require 'sentinel/events'

module Sentinel
  class AbstractAdapter

    @@outputs = []
    @@path = nil


    # Returns formats defined on config/output.yml.
    #
    # @return [Array] An array containing the outputs defined on the file.
    # Default is ['CSV'].
    def self.formats
      @@outputs = YAML.load_file('config/output.yml')['outputs'] if (@@outputs.nil? || @@outputs.empty?)

      (@@outputs.nil? || @@outputs.empty?) ? ['CSV'] : @@outputs
    end

    # Returns the path where to save the ouput files.
    #
    # @returns [String] A string with the path where to save output files.
    # Default is logs/.
    def self.log_dir
      @@path = YAML.load_file('config/output.yml')['directory_path'] if (@@path.nil? || @@path.empty?)

      (@@path.nil? || @@path.empty?) ? 'logs/' : @@path
    end

    # Saves the event on the log file.
    # @param [Object, String] The event received from the IRC channel and a
    # string containing the type of the event.
    # @returns [void]
    def self.save_event(event, type)
      case type
      when Sentinel::Events::MESSAGE
        self.save_message(event)
      else
        self.save_message(event)
      end
    end

    protected

    def self.save_message(message)
      self.formats.each do |output|
        case output
        when 'CSV'
          CSVAdapter.save_message(message)
        else
          CSVAdapter.save_message(message)
        end
      end
    end
  end
end
