# frozen_string_literal: true

# This calls the main test_helper in Foreman-core
require 'test_helper'
require 'database_cleaner'
require 'webmock/minitest'

# Foreman's setup doesn't handle cleaning up for Minitest::Spec
DatabaseCleaner.strategy = :transaction

def fixture(name)
  File.read(File.expand_path("../static_fixtures/#{name}", __FILE__))
end

module Minitest
  class Spec
    before :each do
      DatabaseCleaner.start
    end

    after :each do
      DatabaseCleaner.clean
    end
  end
end
