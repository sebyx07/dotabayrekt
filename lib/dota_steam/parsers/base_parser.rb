module DotaSteam
  module Parsers
    class BaseParser
      attr_reader :status, :result, :http_errors

      def parse
        @status = :pending
        @http_errors = []
      end

      def done?
        @status == :done
      end

      def pending?
        @status == :pending
      end

      def failed?
        @status == :fail
      end

      def successful?
        done? && http_errors.empty?
      end
    end
  end
end