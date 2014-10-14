module Sentinel
  class KeywordsManager

    @@keywords = nil

    # Loads keywords from the appropriate config file
    #
    # @return [Array] The array of keywords
    def self.keywords
      if @@keywords.nil? || @@keywords.empty?
        @@keywords = YAML.load_file('config/keywords.yml')['keywords']
      end

      @@keywords
    end

    # Returns the keywords on a regex format ready to used for matching incoming
    # messages.
    def self.keywords_regex
      string = ""

      # Adds keywords on a string formated for the regex
      self.keywords.each do |keyword|
        string << "(#{keyword})|"
      end

      # Removes the last '|' character from the string
      string.chop!

      Regexp.new(string, Regexp::IGNORECASE)
    end
  end
end
