require 'test_helper'

class UsersTest < ActiveSupport::TestCase

	$SUCCESS = 1
	$ERR_BAD_CREDENTIALS = -1
	$ERR_USER_EXISTS = -2
	$ERR_BAD_USERNAME = -3
	$ERR_BAD_PASSWORD = -4

  test "1 Sign up blank username" do
  	code = User.add(username:"", password:"")
  	assert (code[0] == $ERR_BAD_USERNAME), "Expected sign up failure with blank username,
  	but sign up was successful with code: #{code}"
  end

   test "2 Sign up with a redundant user" do
  	code = User.add(username:"testredundancy",password:"")
  	assert code[0] == $SUCCESS, "Expected to succesfully add new username to database, but failed and got code #{code}"
  	code_redundant = User.add(username:"testredundancy",password:"")
  	assert code_redundant[0] == $ERR_USER_EXISTS, "Expected signing up with user with a username already in database 
  	to fail ('user1') , but was able to save successfully"
  end

  test "3 Password too long" do
  	longPassword = "It was about the deepest sort of beauty, 
  		the product of the human mind being stamped onto a piece of silicon that you might one day cart 
  		around in your briefcase. A poem in a rock. A theorem in a slice of stone. 
  		The programmers were the artisans of the future"

  	code = User.add(username: "testUsernameLen", password: longPassword)
  	assert code[0] == $ERR_BAD_PASSWORD, "Expected signup failure due to password legnth constraint (Password length >> 128), 
  	 but was able to sign up successfully"
  	end

  	test "4 Username exactly 128 characters" do 
  		exactUsername = "The machines would revolutionize the world. 
  		It was not machines that were evil, 
  		but minds of the top brass behind them"

  		code = User.add(username: exactUsername, password: "")
  		assert code[0] == $SUCCESS, "Expected successful sign up with username exactly 128 characters, the allowed
  		maximum, but got the error code #{exactUsername.length}"  
  	end

  	test "5 Login with username not in database" do
  		bad_username = "badUsername"
  		bad_pass = "badPass"
  		User.TESTAPI_resetFixture
  		code = User.login(username: bad_username, password: bad_pass)
  		assert code[0] == $ERR_BAD_CREDENTIALS, "Expected unsucessful login with bad username, but
  		sign in successful, and got code #{code}"
  	end

  	test "6 Login with incorrect pass" do
  		User.TESTAPI_resetFixture
      code = User.login(username: "user1", password: "pass3")
      assert code[0] == $ERR_BAD_CREDENTIALS, "Expected code -1, bad credentials -
      login fail with wrong password, but got code #{code}"
  	end

  	test "7 Login with correct username and pass" do
      User.TESTAPI_resetFixture
      User.add(username:"user1", password: "pass1")
      code = User.login(username:"user1", password: "pass1")
      assert code[0] == $SUCCESS, "Expected success code 1; logged in with correct
      password and username, but got code: #{code}"
  	end

  	test "8 Adding user should set count to 1" do
      User.TESTAPI_resetFixture
      code =User.add(username:"testCount", password: "pass1")
      assert code[0] == $SUCCESS, "Expected success code 1; logged in with correct
      password and username, but got code: #{code}"

      assert code[1] == 1, "Expected count to = 1 when user is added successfully but
      got count = #{code[1]}"
  	end

  	test "9 Add new user and login" do
      User.TESTAPI_resetFixture
      add_code = User.add(username:"testAddandLogin", password: "")
      assert add_code[0] == $SUCCESS, "Adding user failed, got code #{add_code[0]}"

      login_code = User.login(username:"testAddandLogin", password: "")
      assert login_code[0] == $SUCCESS, "Expected succesful login after succssful sign up, but got code #{login_code}"
  	end

  	test "10 Case sensitive sign up" do
      User.TESTAPI_resetFixture
      add_code = User.add(username:"jessica", password: "")
      assert add_code[0] == $SUCCESS, "Adding user 'jessica' failed with code #{add_code}"
      
      add_sensitive = User.add(username:"Jessica", password: "")
      assert add_sensitive[0] == $SUCCESS, "Expecting successful sign up with username 
      same as one in database, but with a capital letter in the beginning. Usernames should be 
      case sensitive, but got the error code: #{add_sensitive}"
  	end


  end