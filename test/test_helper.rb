ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/reporters"

Minitest::Reporters.use!(
      Minitest::Reporters::DefaultReporter.new,
      ENV,
      Minitest.backtrace_filter
    )

class ActiveSupport::TestCase
  fixtures :all
end
