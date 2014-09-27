class UsersController < ApplicationController
  protect_from_forgery

  def new
    @user = Users.new
  end

  def add
    code = Users.add(user_params)
    if code[0] > 0
      render :json => { :errCode => code[0], :count => code[1]}
    else
      render :json => { :errCode => code}
    end
  end

  def login 
    code = Users.login(user_params)
    if code[0] > 0
      render :json => { :errCode => code[0], :count => code[1]}
    else
      render :json => { :errCode => code}
    end
  end

  def TESTAPI_resetFixture
    code = Users.TESTAPI_resetFixture
    render :json => { :errCode => code}
  end

  private 
  def user_params
    params.require(:user).permit(:username, :password)
  end

end
