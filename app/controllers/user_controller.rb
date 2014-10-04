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

  def login 
    response = User.login(user_params)
    #successful login  // correct credentials
    if response[0] > 0
      @user = response[2]
      
      respond_to do |format|
      format.html 
      format.json { 
      render :json => { :errCode => response[0], :count => response[1]} 
      }
    end
    else
      #unsuccessful login
      @user = response[1]
      respond_to do |format|
      format.html { render 'new' }
      format.json { render :json => { :errCode => response[0]} }
    end
  end
  end

  def add
    response = User.add(user_params)
    #successful signup 
    if response[0] > 0
      @user = response[2]
      respond_to do |format|
      format.html
      format.json { render :json => { :errCode => response[0], :count => response[1]} }
    end
    else
      #unsuccessful add
      @user = response[1]
      respond_to do |format|
      format.html { render 'new' }
      format.json { render :json => { :errCode => response[0]} }
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
