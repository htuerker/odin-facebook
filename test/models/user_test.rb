require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = users(:one)
  end

  test "should be valid?" do
    assert @user.valid?
  end

  test 'should have valid first_name' do
    # presence
    @user.first_name = ''
    assert_not @user.valid?
    # length
    @user.first_name = 'a' * 21
    assert_not @user.valid?
    # only letters
    @user.first_name = '1234'
    assert_not @user.valid?
  end

  test 'should have valid last_name' do
    # presence
    @user.last_name = ''
    assert_not @user.valid?
    # length
    @user.last_name = 'a' * 21
    assert_not @user.valid?
    # only letters
    @user.last_name = '1234'
    assert_not @user.valid?
  end
end
