Feature: RSpec–Roles Example

  Background:
    Given a file named "app/lookup.rb" with:
    """ruby
    class Lookup
      def initialize(args)
        @ids = args.fetch :ids
        @repository = args.fetch :repository
        @movie_db = args.fetch :movie_db
      end

      def fetch_and_save
        @repository.create @movie_db.find @ids
      end
    end
    """

    Given a file named "app/movie_repository.rb" with:
    """ruby
    class MovieRepository
      def create(movie_infos)
        # store in database
      end
    end
    """

    Given a file named "app/tmdb.rb" with:
    """ruby
    class Tmdb
      def find(ids)
        ids.map do |id|
          movie_info = connection.get(id)
          { title: movie_info[:title],
            year: movie_info[:year] }
        end
      end

      private

      def connection
        # connect to TMDB
      end
    end
    """

    Given a file named "app/imdb.rb" with:
    """ruby
    class Imdb
      def find(ids)
        ids.map do |id|
          movie_info = connection.get(id)
          { title: movie_info[:title],
            year: movie_info[:year] }
        end
      end

      private

      def connection
        # connect to IMDB
      end
    end
    """

  Scenario: Using usual doubles
    Even when the mocked collaborator's interface changes, the test for the
    client class still passes, using the old interface for the mocks.

    Given a file named "app/imdb.rb" with:
    """ruby
    class Imdb
      def fetch(ids) # not called find anymore
        ids.map do |id|
          movie_info = connection.get(id)
          { title: movie_info[:title],
            year: movie_info[:year] }
        end
      end

      private

      def connection
        # connect to IMDB
      end
    end
    """

    Given a file named "spec/lookup_spec.rb" with:
    """ruby
    require 'spec_helper'
    require 'lookup'
    require 'imdb'

    describe Lookup do
      it 'looks up movie infos and stores them' do
        ids = [1, 2]
        movie_infos = [{ title: 'To Kill A Mockingbird', year: 1962 }]
        movie_db = double('Movie Db')
        repository = double('Repository')

        params = { ids: ids,
          movie_db: movie_db,
          repository: repository }

        lookup = described_class.new(params)

        expect(movie_db).to receive(:find).with(ids).and_return(movie_infos)
        expect(repository).to receive(:create).with(movie_infos)

        lookup.fetch_and_save
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

    Given a file named "app/tmdb.rb" with:
    """ruby
    class Tmdb
      def find(ids) # is still called find, but is not verified by mock
        ids.map do |id|
          movie_info = connection.get(id)
          { title: movie_info[:title],
            year: movie_info[:year] }
        end
      end

      private

      def connection
        # connect to IMDB
      end
    end
    """

    Given a file named "app/imdb.rb" with:
    """ruby
    class Imdb
      def fetch(ids) # not called find anymore
        ids.map do |id|
          movie_info = connection.get(id)
          { title: movie_info[:title],
            year: movie_info[:year] }
        end
      end

      private

      def connection
        # connect to IMDB
      end
    end
    """

    Given a file named "spec/lookup_spec.rb" with:
    """ruby
    require 'spec_helper'
    require 'lookup'
    require 'imdb'

    describe Lookup do
      it 'looks up movie infos and stores them' do
        ids = [1, 2]
        movie_infos = [{ title: 'To Kill A Mockingbird', year: 1962 }]
        movie_db = instance_double('Imdb') # hard dependency
        repository = instance_double('Repository')

        params = { ids: ids,
          movie_db: movie_db,
          repository: repository }

        lookup = described_class.new(params)

        expect(movie_db).to receive(:find).with(ids).and_return(movie_infos)
        expect(repository).to receive(:create).with(movie_infos)

        lookup.fetch_and_save
      end
    end
    """

    Given a file named "spec/spec_helper.rb" with:
    """ruby
    $LOAD_PATH.unshift('app')
    """

    When I run `rspec`
    Then the examples should all fail

  Scenario: Using role doubles
    Given a file named "spec/lookup_spec.rb" with:
    """ruby
    require 'spec_helper'
    require 'lookup'
    require 'roles/movie_db'
    require 'roles/repository'

    describe Lookup do
      it 'looks up movie infos and stores them' do
        ids = [1, 2]
        movie_db = role_double('MovieDb')
        repository = role_double('Repository')
        movie_infos = [{ title: 'To Kill A Mockingbird',
          year: 1962 }]

        params = { ids: ids,
          movie_db: movie_db,
          repository: repository }

        lookup = described_class.new(params)

        expect(movie_db).to receive(:find).with(ids).and_return(movie_infos)
        expect(repository).to receive(:create).with(movie_infos)

        lookup.fetch_and_save
      end
    end
    """

    Given a file named "spec/roles/repository.rb" with:
    """ruby
    RSpec.define_role 'Repository' do
      def create(movie_infos); end
    end
    """

    Given a file named "spec/repository_spec.rb" with:
    """ruby
    require 'spec_helper'
    require 'movie_repository'
    require 'roles/repository'

    describe MovieRepository do
      it_plays_role 'Repository'
    end
    """

    Given a file named "spec/roles/movie_db.rb" with:
    """ruby
    RSpec.define_role 'MovieDb' do
      def find(ids); end
    end
    """

    Given a file named "spec/tmdb_spec.rb" with:
    """ruby
    require 'spec_helper'
    require 'tmdb'
    require 'roles/movie_db'

    describe Tmdb do
      it_plays_role 'MovieDb'
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
    Then the examples should all pass
