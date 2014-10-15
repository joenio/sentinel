require 'csv'
require 'sentinel/adapter'

module Sentinel
  class AbstractAdapter
    class CSVAdapter < AbstractAdapter

      def self.save_message(event)
        p "Testing"
      end
    end
  end
end
