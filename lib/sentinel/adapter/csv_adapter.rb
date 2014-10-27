require 'csv'
require 'fileutils'
require 'sentinel/adapter'

module Sentinel
  class AbstractAdapter
    class CSVAdapter < AbstractAdapter

      # Saves messages in a CSV file
      #
      # @param [Cinch::Message] A IRC messge.
      # @return [void]
      def self.save_message(message)
        begin
          CSV.open(self.output_file_path, 'a', {:force_quotes => true}) do |csv|
            csv << [message.time.to_s, self.channel_name(message), message.user.nick, message.message, self.extract_urls(message)]
          end
        rescue Errno::ENOENT
          FileUtils::mkdir_p self.output_dir
          retry
        end
      end

      private

      # Returns the path to the CSV file.
      #
      # @return [String] A string with the path to the file.
      def self.output_file_path
        output_dir + 'log.csv'
      end
    end
  end
end
