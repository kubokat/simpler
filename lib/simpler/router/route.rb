module Simpler
  class Router
    class Route

      attr_reader :controller, :action, :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @params = {}
      end

      def match?(method, path)
        @method == method && params_parse(path)
      end

      private

      def params_parse(path)

        @params = {}

        until path == @path

          orginal_path_segments = path.split('/')
          path_segments = @path.split('/')

          if orginal_path_segments.size == path_segments.size
            param = path_segments.last.match('^:(\D+)')

            if param
              @params[param[1].to_sym] = orginal_path_segments.last
              return true
            end
          end

          return false
        end

        true
      end

    end
  end
end
