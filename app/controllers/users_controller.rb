class UsersController < ApplicationController
  protect_from_forgery

  def login 
    code = Users.login(user_params)
    if code[0] > 0
      render :json => { :errCode => code[0], :count => code[1]}
      redirect_to user_params[:user]
    else
      render :json => { :errCode => code[0]}
    end
  end

  def add
    code = Users.add(user_params)
    if code[0] > 0
      render :json => { :errCode => code[0], :count => code[1]}
    else
      render :json => { :errCode => code[0]}
    end
  end


  def TESTAPI_resetFixture
    code = Users.TESTAPI_resetFixture
    render :json => { :errCode => code}
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
