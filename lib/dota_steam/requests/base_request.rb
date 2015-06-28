require 'http'
module DotaSteam
  module Requests
    class BaseRequest
      attr_reader :status, :body

      def run
      end
    end
  end
end