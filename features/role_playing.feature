Feature: Playing a role

  Scenario: Spec passes when the method is implemented
    Given a file named "spec/spec_helper.rb" with:
      """ruby
      $LOAD_PATH.unshift('app')
      """

    Given a file named "spec/console_logger_spec.rb" with:
      """ruby
      require 'console_logger'

      describe ConsoleLogger do
        plays_role 'Logger'
      end
      """

    Given a file named "spec/roles/logger.rb" with:
      """ruby
      Rspec.def_role 'Logger' do
        def log(message); end
      end
      """

    Given a file named "app/console_logger.rb" with:
      """ruby
      class ConsoleLogger
        def log(message)
          puts message
        end
      end
      """

    When I run `rspec -r./spec/spec_helper spec/console_logger_spec.rb`
    Then the examples should all pass
