Feature: Initialize mocks with allowed calls

  Scenario: mock allows the predefined calls and returns value
    Given a file named "spec/roles/fetcher.rb" with:
      """ruby
      RSpec.define_role 'Fetcher' do
        def fetch(id) end
      end
      """

    And a file named "spec/spec_helper.rb" with:
      """ruby
      require 'rspec/role-mocks'
      $LOAD_PATH.unshift("lib")
      """

    Given a file named "lib/user.rb" with:
      """ruby
      class User < Struct.new(:fetcher)
        def favorite_artist
          fetcher.fetch(1)
        end
      end
      """

    And a file named "spec/user_spec.rb" with:
      """ruby
      require 'spec_helper'
      require 'user'
      require 'roles/fetcher'

      RSpec.describe User, '#suspend!' do
        it 'notifies the console' do
          expected = 'Theolonious Monk'
          fetcher = role_double("Fetcher", fetch: expected)
          user = User.new(fetcher)

          actual = user.favorite_artist

          expect(actual).to eq expected
        end
      end
      """

    When I run `rspec spec/user_spec.rb`
    Then the example should pass
