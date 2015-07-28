require 'json'
module DotaSteam
  module Cache
    class BaseCache
      attr_accessor :json

      def initialize(file_path, root_path)
        json = JSON.parse(File.read(file_path))
        @json = symbolize_keys(json)[root_path]
      end

      def get(id)
        @json.find { |el|  el[:id] == id }
      end

      protected
      def symbolize_keys(obj)
        case obj
          when Array
            obj.inject([]){|res, val|
              res << case val
                       when Hash, Array
                         symbolize_keys(val)
                       else
                         val
                     end
              res
            }
          when Hash
            obj.inject({}){|res, (key, val)|
              nkey = case key
                       when String
                         key.to_sym
                       else
                         key
                     end
              nval = case val
                       when Hash, Array
                         symbolize_keys(val)
                       else
                         val
                     end
              res[nkey] = nval
              res
            }
          else
            obj
        end
      end
    end
  end
end