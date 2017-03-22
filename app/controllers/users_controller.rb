class UsersController < ApplicationController
  before_filter :signed_in_user,     only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,       only: [:edit, :update]
  before_filter :admin_user,         only: :destroy
  before_filter :not_signed_in_user, only: [:new, :create]

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def new
  	@user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def destroy
    @user = User.find(params[:id])
    unless current_user?(@user)
      @user.destroy
      flash[:success] = "User destroyed."
    else
      flash[:error] = "Can't delete self."
    end
    redirect_to users_url
  end

  def index
    @users = User.paginate(page: params[:page])
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

private

    def not_signed_in_user
      unless !signed_in?
        redirect_to(root_url)
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
