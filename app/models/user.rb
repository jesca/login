class User < ActiveRecord::Base
	validates :username, presence: true, length: {maximum: 128}

	$SUCCESS = 1
	$ERR_BAD_CREDENTIALS = -1
	$ERR_USER_EXISTS = -2
	$ERR_BAD_USERNAME = -3
	$ERR_BAD_PASSWORD = -4

	def self.login(user_params)
		loginUser = User.find_by_username_and_password(user_params[:username],user_params[:password])
	  	if loginUser != nil
	  		loginUser.count += 1
	  		loginUser.save
	  		return [$SUCCESS, loginUser.count, loginUser]
	  	else
	  		#wrong password
	  		return [$ERR_BAD_CREDENTIALS, loginUser]
	  	end
	  end


	def self.add(user_params)
	    user = User.find_by_username(user_params[:username])

		name = user_params[:username]
		pass = user_params[:password]
		# ensure that length of username cannot be 0, and len of both username and pass <= 128
		if name.length < 1  || name.length > 128
	    	return [$ERR_BAD_USERNAME, user]
	    elsif pass.length > 128
	    	return [$ERR_BAD_PASSWORD, user]
	    end
	   

	    if user != nil
	    	return [$ERR_USER_EXISTS, user]

	    else
	    	user = User.new(user_params)
	    	user.count = 1
	    	user.save
	    		return $SUCCESS, user.count, user
	    end
	end
	
	  def self.TESTAPI_resetFixture
	  	User.delete_all
	  	return $SUCCESS
	  end
	
	end