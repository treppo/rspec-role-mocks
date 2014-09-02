module RSpec
  module Roles
    module Doubles
      @doubles = []

      class << self
        def register(double)
          @doubles << double
          double
        end

        def verify
          @doubles.each {|dbl| dbl.verify }
        end

        def reset!
          @doubles = []
        end
      end
    end
  end
end
