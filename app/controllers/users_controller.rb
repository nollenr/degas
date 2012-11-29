class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to :users
    else
      render 'new'
    end
  end

  def index
    @users = User.order("username")
  end

end
