require 'strscan'
require 'json/common'
require 'json/pure/parser'

module JSON
  module Spec
    class Parser < JSON::Pure::Parser
      DATA_TYPE             = /[A-Z][a-z]*/
      ELIPSIS               = /\.\.\./
      def parse_string
        if scan(DATA_TYPE)
          self[0].intern
        else
          super
        end
      end

      def parse_value
        case
        when skip(ELIPSIS)
          :more
        else
          super
        end
      end
    end
  end
end

spec = JSON::Spec::Parser.new(%{[{String: Integer}, ...]}).parse
