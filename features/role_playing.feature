Feature: Playing a role

  Background:
    Given a file named "spec/spec_helper.rb" with:
      """ruby
      require 'rspec/roles'

      $LOAD_PATH.unshift('app')
      """

    Given a file named "spec/console_logger_spec.rb" with:
      """ruby
      require 'spec_helper'
      require 'console_logger'
      require 'roles/logger'

      describe ConsoleLogger do
        plays_role 'Logger'
      end
      """

    Given a file named "spec/roles/logger.rb" with:
      """ruby
      RSpec::Roles.define 'Logger' do
        def log(message); end
      end
      """

  Scenario: Spec passes when the object plays the role
    Given a file named "app/console_logger.rb" with:
      """ruby
      class ConsoleLogger
        def log(message)
          puts message
        end
      end
      """

    When I run `rspec spec/console_logger_spec.rb`
    Then the example should pass

  Scenario: Spec fails when the object does not play the role
    Given a file named "app/console_logger.rb" with:
      """ruby
      class ConsoleLogger
        def not_log(message)
          puts message
        end
      end
      """

    When I run `rspec spec/console_logger_spec.rb`
    Then the example should fail
