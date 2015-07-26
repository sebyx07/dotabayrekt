module DotaSteam
  class ApiKeyProvider

    class << self
      def mutex
        @mutex ||= Mutex.new
      end

      undef_method :new

      def get_key
        DotaSteam.configuration.api_keys[index]
      end

      private
      def index
        mutex.synchronize do
          if !@index  || @index + 2 > DotaSteam.configuration.api_keys.size
            @index = 0
          else
            @index += 1
          end

          @index
        end
      end
    end
  end
end