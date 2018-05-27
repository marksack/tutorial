require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin     = users(:admin)
    @non_admin = users(:test1)
  end

  test 'index as admin including pagination and delete links' do
    log_in_as(@admin)
    activated_count = User.where(activated: true).count
    num_pages = (activated_count / 30).zero? ? activated_count / 30 : (activated_count / 30) + 1
    (1..num_pages).each do |page_num|
      get users_path(page: page_num)
      assert_template 'users/index'
      assert_select 'ul.pagination'
      page_of_users = User.where(activated: true).paginate(page: page_num)
      page_of_users.each do |user|
        assert_select 'a[href=?]', user_path(user), text: user.name
        unless user == @admin
          assert_select 'a[href=?]', user_path(user), text: 'delete'
        end
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test 'index as non-admin' do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end
