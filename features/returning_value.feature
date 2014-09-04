Feature: Returning a value

  Background:
    Given a file named "spec/roles/notifier.rb" with:
      """ruby
      RSpec.define_role 'Notifier' do
        def notify; end
      end
      """

    And a file named "spec/spec_helper.rb" with:
      """ruby
      require 'rspec/roles'

      $LOAD_PATH.unshift("lib")
      """

  Scenario: Return nil by default
    Given a file named "spec/user_spec.rb" with:
      """ruby
      require 'spec_helper'
      require 'roles/notifier'

      RSpec.describe 'Default return value' do
        it 'notifies the console' do
          notifier = role_double("Notifier")

          expect(notifier).to receive(:notify)

          expect(notifier.notify).to be_nil
        end
      end
      """

    When I run `rspec spec/user_spec.rb`
    Then the examples should all pass

  Scenario: Specify a return value
    Given a file named "spec/user_spec.rb" with:
      """ruby
      require 'spec_helper'
      require 'roles/notifier'

      RSpec.describe 'Specified return value' do
        it 'notifies the console' do
          notifier = role_double("Notifier")

          expect(notifier).to receive(:notify).and_return(1)

          expect(notifier.notify).to eq(1)
        end
      end
      """

    When I run `rspec spec/user_spec.rb`
    Then the examples should all pass
