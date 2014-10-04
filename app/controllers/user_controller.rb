class UserController < ApplicationController
  protect_from_forgery

  def show
  end
  
  def index
    @user = User.all
  end

  # GET /login
  def new
    @user = User.new
  end

  def update
     if params[:login]
      puts "creds", (@user)
      self.login
    else
      self.add
    end
  end

  def login 
    response = User.login(user_params)
    #successful login  // correct credentials
    code = response[0]
    if code > 0
      @user = response[2]
      respond_to do |format|
      format.html 
      format.json { render :json => { :errCode => response[0], :count => response[1]}  }
      end

    elsif code == -1
      #unsuccessful login
      @user = User.new
      @user.errors.add(:username,"Invalid username and password combination. Please try again")
      respond_to do |format|
      format.html { render 'new' }
      format.json { render :json => { :errCode => response[0]} }
      end
    end

  end


  def add
    response = User.add(user_params)
    #successful signup 
    code = response[0]
    if code > 0
      @user = response[2]
      respond_to do |format|
      format.html
      format.json { render :json => { :errCode => response[0], :count => response[1]} }
      end
    end

    if code == -2
      #already exists
      @user = response[1]
      @user.errors.add(:username,"This username already exists. Please try again.")
      respond_to do |format|
      format.html { render 'new' }
      format.json { render :json => { :errCode => response[0] } }
      end
    elsif code == -3
       @user = User.new
       @user.errors.add(:username,"The user name should be non-empty and at most 128 characters long. Please try again.")
       respond_to do |format|
      format.html { render 'new' }
      format.json { render :json => { :errCode => response[0] } }
      end
    elsif code == -4
       @user =  User.new
       @user.errors.add(:username,"The password should be at most 128 characters long. Please try again.")
       respond_to do |format|
      format.html { render 'new' }
      format.json { render :json => { :errCode => response[0] } }
      end
    end
      
    end

  

  # after clicking submit button on form, either login or add
  def create
    if params[:login]
      self.login
    else
      self.add
    end
  end

  def TESTAPI_resetFixture
    response = User.TESTAPI_resetFixture
    render :json => { :errCode => response}
  end

    """
    Output should look like this: 

    # Running:

    ..........

    Finished in 0.049780s, 200.8839 runs/s, 281.2374 assertions/s.

    10 runs, 14 assertions, 0 failures, 0 errors, 0 skips
    """

#http://www.ruby-doc.org/core-2.1.2/String.html#method-i-lines
 def unitTests
      # get line first, split by ",", get number
      rakeTest = `rake test`
      console = rakeTest.split("\n")[-1].split(",")
      totalTests = console[0].split(" ")[0].scan(/\d+/)[0]
      failedTests = console[console.length-1].scan(/\d+/)[0]
      render :json => {:totalTests => Integer(totalTests), :nrFailed => Integer(failedTests), :output => rakeTest}
  end

  private 
  def user_params
    params.require(:user).permit(:username, :password)
  end

end