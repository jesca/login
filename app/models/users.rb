class Users < ActiveRecord::Base
	validates :username, presence: true, length: {maximum: 128}

	$SUCCESS = 1
	$ERR_BAD_CREDENTIALS = -1
	$ERR_USER_EXISTS = -2
	$ERR_BAD_USERNAME = -3
	$ERR_BAD_PASSWORD = -4

	def self.login(user_params)
		loginUser = Users.find_by_username_and_password(user_params[:username],user_params[:password])
	  	if loginUser != nil
	  		loginUser.count += 1
	  		loginUser.save
	  		return [$SUCCESS, loginUser.count]
	  	else
	  		#wrong password
	  		return [$ERR_BAD_CREDENTIALS]
	  	end
	  end


	def self.add(user_params)
		name = user_params[:username]
		pass = user_params[:password]
		# ensure that length of username cannot be 0, and len of both username and pass <= 128
		if name.length < 1 || name.length > 128
	    	return $ERR_BAD_USERNAME
	    elsif pass.length > 128
	    	return $ERR_BAD_PASSWORD
	    end
	    
	    user = Users.find_by_username(user_params[:username])
	    if user != nil
	    	 user.errors.add(:username,"This username already exists. Please try again.")
	    	return $ERR_USER_EXISTS

	    else
	    	user = Users.new(user_params)
	    	user.count = 1
	    	if user.save
	    		return $SUCCESS, user.count
	    	end
	    end
	end
	
	  def self.TESTAPI_resetFixture
	  	Users.delete_all
	  	return $SUCCESS
	  end

	  private
	  def user_params
	  	params.require(:user).permit(:username, :password)
	  end

	
	end