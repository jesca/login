class Users < ActiveRecord::Base
	validates :username, presence: true, length: {maximum: 128}
	before_save { self.username = username.downcase }


	$SUCCESS = 1
	$ERR_BAD_CREDENTIALS = -1
	$ERR_USER_EXISTS = -2
	$ERR_BAD_USERNAME = -3
	$ERR_BAD_PASSWORD = -4

	def self.add(user_params)
		name = user_params[:username]
		pass = user_params[:password]
		# ensure that length of username cannot be 0, and len of both username and pass <= 128
		if name.length == 0 || name.length > 128
	    	return $ERR_BAD_USERNAME
	    elsif pass.length > 128
	    	return $ERR_BAD_PASSWORD
	    end
	    
	    @user = Users.find_by_username(user_params[:username])
	    if @user != nil
	    	 @user.errors.add(:username,"This username already exists. Please try again.")
	    	return $ERR_USER_EXISTS
	    else
	    	@user = Users.new(user_params)
	    	@user.count = 1
	    	if @user.save
	    		return $SUCCESS, @user.count
	    	end
	    end
	end

	def self.login(user_params)
		@user = Users.find_by_username(user_params[:username])
	  	if @user == nil
	  		return $ERR_BAD_CREDENTIALS
	  	end
	  	if (@user.password) == user_params[:password]
	  		@user.count += 1
	  		@user.save
	  		return $SUCCESS, @user.count
	  	else
	  		#wrong password
	  		return $ERR_BAD_CREDENTIALS
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