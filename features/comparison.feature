Feature: Rspec–Roles Comparison
  A comparison of Rspec's builtin mocking features and Rspec–Roles

  Background:
    Given a file named "app/lookup.rb" with:
    """ruby
    class Lookup
      def initialize(args)
        @ids = args.fetch :ids
        @movie_db = args.fetch :movie_db
      end

      def movie_info
        @movie_db.find @ids #expects the movie_db to respond to #find
      end
    end
    """

    Given a file named "app/imdb.rb" with:
    """ruby
    class Imdb
      def fetch(ids) # not called find anymore
      end
    end
    """

  Scenario: Using usual rspec doubles
    Even when the mocked collaborator's interface changes, the test for the
    client class still passes, using the old interface for the mocks.

    Given a file named "spec/lookup_spec.rb" with:
    """ruby
    require 'spec_helper'
    require 'lookup'

    describe Lookup do
      it 'looks up movie infos and stores them' do
        ids = [1, 2]
        movie_db = double('MovieDb')
        lookup = described_class.new(ids: ids, movie_db: movie_db)

        expect(movie_db).to receive(:find).with(ids)

        lookup.movie_info
      end
    end
    """

    Given a file named "spec/spec_helper.rb" with:
    """ruby
    $LOAD_PATH.unshift('app')
    """

    When I run `rspec`
    Then the examples should all pass

  Scenario: Using verified mocks
    Using verified mocks, every change to the collaborator's interface leads to
    a failing test for the client class – this is a good thing. But the
    mock is bound to the concrete implementation, therefore creating unnecessary
    coupling. Swapping that collaborator to a different implementation, breaks
    the test, even when the new collaborator is implementing the same interface.

    While designing the system, mocks are a useful tool to explore a
    collaborator's interface. With the verifying mocks, the collaborator
    implementation already has to be in place, or the test will fail. The
    developer does not get the benefit of putting off the creation of the
    concrete class.

    Given a file named "spec/lookup_spec.rb" with:
    """ruby
    require 'spec_helper'
    require 'lookup'
    require 'imdb'

    describe Lookup do
      it 'looks up movie infos and stores them' do
        ids = [1, 2]
        movie_db = instance_double('Imdb') # hard dependency
        lookup = described_class.new(ids: ids, movie_db: movie_db)

        expect(movie_db).to receive(:find).with(ids)

        lookup.movie_info
      end
    end
    """

    Given a file named "spec/spec_helper.rb" with:
    """ruby
    $LOAD_PATH.unshift('app')
    """

    When I run `rspec`
    Then the examples should all fail

  Scenario: Using role–based mocks
    Given a file named "spec/lookup_spec.rb" with:
    """ruby
    require 'spec_helper'
    require 'lookup'
    require 'roles/movie_db'

    describe Lookup do
      it 'looks up movie infos and stores them' do
        ids = [1, 2]
        movie_db = role_double('MovieDb') # no dependency on concrete class
        lookup = described_class.new(ids: ids, movie_db: movie_db)

        expect(movie_db).to receive(:find).with(ids)

        lookup.movie_info
      end
    end
    """

    Given a file named "spec/roles/movie_db.rb" with:
    """ruby
    RSpec.define_role 'MovieDb' do
      def find(ids); end
    end
    """

    Given a file named "spec/imdb_spec.rb" with:
    """ruby
    require 'spec_helper'
    require 'imdb'
    require 'roles/movie_db'

    describe Imdb do
      it_plays_role 'MovieDb'
    end
    """

    Given a file named "spec/spec_helper.rb" with:
    """ruby
    require 'rspec/roles'
    $LOAD_PATH.unshift('app')
    """

    When I run `rspec`
    Then 1 example should fail
