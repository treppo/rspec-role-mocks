Feature: Playing a role

  Background:
    Given a file named "spec/spec_helper.rb" with:
      """ruby
      require 'rspec/roles'

      $LOAD_PATH.unshift('app')
      """

    Given a file named "spec/roles/logger.rb" with:
      """ruby
      RSpec::Roles.define 'Logger' do
        def initialize(opts); end
        def self.create(opts); end
        def log(message); end
      end
      """

    Given a file named "spec/roles/writer.rb" with:
      """ruby
      RSpec::Roles.define 'Writer' do
        def write(message, opts); end
      end
      """

    Given a file named "spec/console_logger_spec.rb" with:
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

  Scenario: Spec passes when the object plays all the roles
    Given a file named "app/console_logger.rb" with:
      """ruby
      class ConsoleLogger
        def initialize(opts); end
        def self.create(opts); end
        def log(message); end
        def write(message, opts); end
      end
      """

    When I run `rspec spec/console_logger_spec.rb`
    Then the example should pass

  Scenario: Spec fails when the object does not play all the roles
    Given a file named "app/console_logger.rb" with:
      """ruby
      class ConsoleLogger
        def not_log(message); end
        def not_write(message); end
      end
      """

    When I run `rspec spec/console_logger_spec.rb`
    Then the example should fail
