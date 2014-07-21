require_relative 'double_verifier'

module RSpec
  module Roles
    module Doubles
      @doubles = []

      class << self
        def register(double)
          @doubles << double
          double
        end

        def verify(verifier = DoubleVerifier)
          @doubles.each {|dbl| verifier.verify(dbl) }
        end

        def reset!
          @doubles = []
        end
      end
    end
  end
end
