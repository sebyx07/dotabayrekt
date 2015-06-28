module DotaSteam
  class ApiKeyProvider
    KEYS = ['EE4B46697AAE3B64E5E4334E10E7AB0F']

    class << self
      def mutex
        @mutex ||= Mutex.new
      end

      undef_method :new

      def get_key
        KEYS[index]
      end


      private
      def index
        mutex.synchronize do
          if !@index  || @index > KEYS.size
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