Feature: Mocking roles, not objects

  Background:
    Given a file named "spec/roles/notifier.rb" with:
      """ruby
      RSpec.define_role 'Notifier' do
        def notify(message); end
      end
      """

    And a file named "spec/spec_helper.rb" with:
      """ruby
      require 'rspec/roles'

      $LOAD_PATH.unshift("lib")
      """

    And a file named "spec/user_spec.rb" with:
      """ruby
      require 'spec_helper'
      require 'user'
      require 'roles/notifier'

      RSpec.describe User, '#suspend!' do
        it 'notifies the console' do
          notifier = role_double("Notifier")

          expect(notifier).to receive(:notify).with("suspended")

          user = User.new(notifier)
          user.suspend!
        end
      end
      """

  Scenario: spec passes with method defined
    Given a file named "lib/user.rb" with:
      """ruby
      class User < Struct.new(:notifier)
        def suspend!
          notifier.notify("suspended")
        end
      end
      """

    When I run `rspec spec/user_spec.rb`
    Then the examples should all pass

  Scenario: spec fails with method not called
    Given a file named "lib/user.rb" with:
      """ruby
      class User < Struct.new(:notifier)
        def suspend!
        end
      end
      """

    When I run `rspec spec/user_spec.rb`
    Then the example should fail
    And the output should contain "expected method call to #notify on role double Notifier was never made"

  Scenario: spec fails with method not defined
    Given a file named "lib/user.rb" with:
      """ruby
      class User < Struct.new(:notifier)
        def suspend!
          notifier.notify("suspended")
          notifier.call
        end
      end
      """

    When I run `rspec spec/user_spec.rb`
    Then the example should fail
    And the output should contain "role double Notifier does not implement: #call"

  Scenario: spec fails with incorrect arity
    Given a file named "lib/user.rb" with:
      """ruby
      class User < Struct.new(:notifier)
        def suspend!
          notifier.notify
        end
      end
      """

    When I run `rspec spec/user_spec.rb`
    Then the output should contain "1 example, 1 failure"
    And the output should contain "Wrong number of arguments for #notify on role double Notifier"
    And the output should contain "Actual: 0"
    And the output should contain "Expected: 1"

  Scenario: spec fails with incorrect argument
    Given a file named "lib/user.rb" with:
      """ruby
      class User < Struct.new(:notifier)
        def suspend!
          notifier.notify('not_suspend')
        end
      end
      """

    When I run `rspec spec/user_spec.rb`
    Then the output should contain "1 example, 1 failure"
    And the output should contain:
    """
    Method #notify on role double Notifier received wrong arguments: "not_suspend"
    """
    And the output should contain:
    """
    expected arguments: "suspended"
    """
