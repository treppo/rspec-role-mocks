Feature: Playing multiple roles

  Background:
    Given a file named "spec/spec_helper.rb" with:
      """ruby
      require 'rspec/role-mocks'
      $LOAD_PATH.unshift('lib')
      """

    And a file named "spec/roles/logger.rb" with:
      """ruby
      RSpec.define_role 'Logger' do
        def log(message); end
      end
      """

    And a file named "spec/roles/writer.rb" with:
      """ruby
      RSpec.define_role 'Writer' do
        def write(message, opts); end
      end
      """

    And a file named "spec/console_logger_spec.rb" with:
      """ruby
      require 'spec_helper'
      require 'console_logger'
      require 'roles/logger'
      require 'roles/writer'

      describe ConsoleLogger do
        it_plays_role 'Logger'
        it_plays_role 'Writer'
      end
      """

  Scenario: Object plays all the roles
    Given a file named "lib/console_logger.rb" with:
      """ruby
      class ConsoleLogger
        def log(message); end
        def write(message, opts); end
      end
      """

    When I run `rspec spec/console_logger_spec.rb`
    Then the example should pass

  Scenario: Object does not play all the roles
    Given a file named "lib/console_logger.rb" with:
      """ruby
      class ConsoleLogger
        def not_log(message); end
        def not_write(message); end
      end
      """

    When I run `rspec spec/console_logger_spec.rb`
    Then the example should fail
    And the output should contain:
    """
    ConsoleLogger does not play role "Logger" as expected
    """
    And the output should contain:
    """
    ConsoleLogger does not play role "Writer" as expected
    """
