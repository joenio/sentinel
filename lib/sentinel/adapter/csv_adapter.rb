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
      def self.save_message_with_keyword(message)
        begin
          CSV.open(self.output_file_path, 'a', {:force_quotes => true}) do |csv|
            csv << [message.time.to_s, self.channel_name(message), message.user.nick, message.message, self.extract_urls(message)]
          end
        rescue Errno::ENOENT
          FileUtils::mkdir_p self.output_dir
          retry
        end
      end

      # Saves messages in a CSV file
      #
      # @param [Cinch::Message] A IRC messge.
      # @return [void]
      def self.save_message(message)
        begin
          CSV.open(self.output_dir + self.channel_name(message) + '.csv', 'a', {:force_quotes => true}) do |csv|
            csv << [message.time.to_s, "MESSAGE", message.user.nick, message.message]
          end
        rescue Errno::ENOENT
          FileUtils::mkdir_p self.output_dir
          retry
        end
      end

      # Saves private messages in a CSV file
      #
      # @param [Cinch::Message] A IRC messge.
      # @return [void]
      def self.save_private_messages(message)
        begin
          CSV.open(self.output_dir + self.channel_name(message) + '.csv', 'a', {:force_quotes => true}) do |csv|
            csv << [message.time.to_s, "PRIVATE_MESSAGE", message.user.nick, message.message]
          end
        rescue Errno::ENOENT
          FileUtils::mkdir_p self.output_dir
          retry
        end
      end

      # Saves join events in a CSV file
      #
      # @param [Cinch::Message] A IRC messge.
      # @return [void]
      def self.save_join(event)
        begin
          CSV.open(self.output_dir + self.channel_name(event) + '.csv', 'a', {:force_quotes => true}) do |csv|
            csv << [event.time.to_s, "JOIN", event.user.nick, ""]
          end
        rescue Errno::ENOENT
          FileUtils::mkdir_p self.output_dir
          retry
        end
      end

      # Saves leave events in a CSV file
      #
      # @param [Cinch::Message] A IRC messge.
      # @return [void]
      def self.save_leaving(event)
        begin
          CSV.open(self.output_dir + self.channel_name(event) + '.csv', 'a', {:force_quotes => true}) do |csv|
            csv << [event.time.to_s, "LEAVE", event.user.nick, ""]
          end
        rescue Errno::ENOENT
          FileUtils::mkdir_p self.output_dir
          retry
        end
      end

      # Saves change of topic events in a CSV file
      #
      # @param [Cinch::Message] A IRC messge.
      # @return [void]
      def self.save_topic(event)
        begin
          CSV.open(self.output_dir + self.channel_name(event) + '.csv', 'a', {:force_quotes => true}) do |csv|
            csv << [event.time.to_s, "TOPIC", "", event.message]
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
