module DotaSteam
  module Parsers
    class BaseParser
      attr_reader :status, :result

      def parse
        @status = :pending
      end
    end
  end
end