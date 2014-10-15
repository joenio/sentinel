require 'csv'
require 'fileutils'
require 'sentinel/adapter'

module Sentinel
  class AbstractAdapter
    class CSVAdapter < AbstractAdapter

      def self.save_message(message)
        begin
          CSV.open(self.log_file_path, 'a') do |csv|
            csv << [message.time.to_s, message.channel.name, message.user.nick, message.message]
          end
        rescue Errno::ENOENT
          FileUtils::mkdir_p self.log_dir
          retry
        end
      end

      private

      def self.log_file_path
        log_dir + 'log.csv'
      end
    end
  end
end
