class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:edit, :update, :index]
  before_filter :correct_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      redirect_to :users, notice: "User created."
    else
      render 'new'
    end
  end

  def index
    @users = User.order("username")
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      sign_in @user
      redirect_to bottles_path
    else
      render 'edit'
    end
  end

  private

    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        redirect_to root_path, notice: "Cannot edit another user's profile"
      end
    end

end
