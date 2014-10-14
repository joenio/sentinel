module Sentinel
  module Extractor

    # Returns formats defined on config/output.yml.
    #
    # @return [Array] An array containing the outputs defined on the file.
    # Default is ['CSV'].
    def self.formats
      outputs = YAML.load_file('config/output.yml')['outputs']

      (outputs.nil? || outputs.empty?) ? ['CSV'] : outputs
    end

    # Returns the path where to save the ouput files.
    #
    # @returns [String] A string with the path where to save output files.
    # Default is logs/.
    def self.path
      path = YAML.load_file('config/output.yml')['directory_path']

      (path.nil? || path.empty?) ? 'logs/' : path
    end
  end
end
