require File.expand_path('../helper', __FILE__)

begin
    require "rubygems"
	require 'fdb'
	class FDBAdapterTest < Guillotine::TestCase
	    def setup
	      FDB.api_version 200
	      @fdb_db = FDB.open
	      @fdb_db.clear_range('', '\xFF')

	      @db = Guillotine::FDBAdapter.new(@fdb_db)
	    end

	    def test_adding_a_link_returns_code
	      @db.add 'abc'

	      code = @db.add 'abc'
	      assert_equal 'abc', @db.find(code)
	    end

	    def test_adding_duplicate_link_returns_same_code
	      code = @db.add 'abc'
	      assert_equal code, @db.add('abc')
	    end

	    def test_adds_url_with_custom_code
	      assert_equal 'code', @db.add('def', 'code')
	      assert_equal 'def', @db.find('code')
	    end

	    def test_clashing_urls_raises_error
	      code = @db.add 'abc'
	      assert_raise Guillotine::DuplicateCodeError do
	        @db.add 'ghi', code
	      end
	    end

	    def test_missing_code
	      assert_nil @db.find('missing')
	    end

	    def test_gets_code_for_url
	      code = @db.add 'abc'
	      assert_equal code, @db.code_for('abc')
	    end

	    def test_clears_code_for_url
	      code = @db.add 'abc'
	      assert_equal 'abc', @db.find(code)

	      @db.clear 'abc'

	      assert_nil @db.find(code)
	    end
	end
rescue LoadError
  puts "Skipping FoundationDB tests: #{$!}"
end
