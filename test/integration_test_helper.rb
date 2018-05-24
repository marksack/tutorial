module IntegrationTestHelper
  def test_is_logged_in?
    !session[:user_id].nil?
  end
end
