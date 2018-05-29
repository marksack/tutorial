require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test1)
  end

  test 'micropost interface' do
    log_in_as(@user)
    get root_path
    assert_select 'ul.pagination'
    assert_select 'input[type=file]'

    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: '' } }
    end
    assert_select 'div#error_explanation'

    content = 'This micropost really ties the room together'
    picture = fixture_file_upload('test/fixtures/testimage.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content, picture: picture } }
    end
    assert @user.microposts.first.picture.attached?
    follow_redirect!
    assert_match content, response.body

    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end

    get user_path(users(:test2))
    assert_select 'a', text: 'delete', count: 0
  end

  test 'micropost sidebar count' do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body

    other_user = users(:test4)
    log_in_as(other_user)
    get root_path
    assert_match '0 microposts', response.body
    other_user.microposts.create!(content: 'A micropost')
    get root_path
    assert_match '1 micropost', response.body
  end
end
