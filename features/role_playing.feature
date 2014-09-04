Feature: Playing a role

  Background:
    Given a file named "spec/spec_helper.rb" with:
      """ruby
      require 'rspec/roles'
      $LOAD_PATH.unshift('lib')
      """

    And a file named "spec/roles/logger.rb" with:
      """ruby
      RSpec.define_role 'Logger' do
        def log(message, opts = {}, &block); end
      end
      """

    And a file named "spec/console_logger_spec.rb" with:
      """ruby
      require 'spec_helper'
      require 'console_logger'
      require 'roles/logger'

      describe ConsoleLogger do
        it_plays_role 'Logger'
      end
      """

  Scenario: Object plays the role
    Given a file named "lib/console_logger.rb" with:
      """ruby
      class ConsoleLogger
        def log(message, opts = {}, &block); end
      end
      """

    When I run `rspec spec/console_logger_spec.rb`
    Then the example should pass

  Scenario: Object does not play the role
    Given a file named "lib/console_logger.rb" with:
      """ruby
      class ConsoleLogger
        def not_log(message); end
      end
      """

    When I run `rspec spec/console_logger_spec.rb`
    Then the example should fail
    And the output should contain:
    """
    ConsoleLogger does not play role "Logger" as expected
    """

  Scenario: Object has other method arity
    Given a file named "lib/console_logger.rb" with:
      """ruby
      class ConsoleLogger
        def log(message); end
      end
      """

    When I run `rspec spec/console_logger_spec.rb`
    Then the example should fail
    And the output should contain:
    """
    ConsoleLogger does not play role "Logger" as expected
    """

  Scenario: Object has other method argument type
    Given a file named "lib/console_logger.rb" with:
      """ruby
      class ConsoleLogger
        def log(message, opts = {}, no_block); end
      end
      """

    When I run `rspec spec/console_logger_spec.rb`
    Then the example should fail
    And the output should contain:
    """
    ConsoleLogger does not play role "Logger" as expected
    """
