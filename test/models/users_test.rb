require 'test_helper'

class UsersTest < ActiveSupport::TestCase

	$SUCCESS = 1
	$ERR_BAD_CREDENTIALS = -1
	$ERR_USER_EXISTS = -2
	$ERR_BAD_USERNAME = -3
	$ERR_BAD_PASSWORD = -4

  test "1 Sign up blank username" do
  	code = Users.add(username:"", password:"")
  	assert (code == $ERR_BAD_USERNAME), "Expected sign up failure with blank username,
  	but sign up was successful"
  end

   test "2 Sign up with a redundant user" do
  	code = Users.add(username:"testredundancy",password:"")
  	assert code == $SUCCESS, "Expected to succesffully add new username to databaes, but failed"
  	code_redundant = Users.add(username:"testredundancy",password:"")
  	assert code_redundant == $ERR_USER_EXISTS, "Expected signing up with user with a username already in database 
  	to fail ('user1') , but was able to save successfully"
  end

  test "3 Password too long" do
  	longPassword = "It was about the deepest sort of beauty, 
  		the product of the human mind being stamped onto a piece of silicon that you might one day cart 
  		around in your briefcase. A poem in a rock. A theorem in a slice of stone. 
  		The programmers were the artisans of the future"

  	code = Users.add(username: "testUsernameLen", password: longPassword)
  	assert code == $ERR_BAD_PASSWORD, "Expected signup failure due to password legnth constraint (Password length >> 128), 
  	 but was able to sign up successfully"
  	end

  	test "4 Username exactly 128 characters" do 
  		exactUsername = "The machines would revolutionize the world. 
  		It was not machines that were evil, 
  		but minds of the top brass behind them"

  		code = Users.add(username: exactUsername, password: "")
  		assert code == $SUCCESS, "Expected successful sign up with username exactly 128 characters, the allowed
  		maximum, but got the error code #{exactUsername.length}"  
  	end

  	test "5 Login with username not in database" do
  		bad_username = "badUsername"
  		bad_pass = "badPass"
  		Users.TESTAPI_resetFixture
  		code = Users.login(username: bad_username, password: bad_pass)
  		assert code == $ERR_BAD_CREDENTIALS, "Expected unsucessful login with bad username, but
  		sign in successful, and got code #{code}"
  	end

  	test "6 Login with incorrect pass" do
  		Users.TESTAPI_resetFixture
  	end

  	test "7 Login with correct username and pass" do
      code = Users.login(username:"user1", password: "pass1")
      assert code == $SUCCESS, 5
  	end

  	test "8 Login should increase count" do
  	end

  	test "9 Add new user and login" do
  	end

  	test "10 Case sensitive sign up" do
  	end


  end