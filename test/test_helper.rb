ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!

ASSERT_NOT_LOGGED_IN = 'assert session[:user_id].nil?'
ASSERT_LOGGED_IN = 'assert_not session[:user_id].nil?'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper
end

class ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end
