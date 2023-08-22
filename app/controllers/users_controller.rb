class UsersController < ApplicationController
  # protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def login
    @user = User.find_by(email: params[:email], password: params[:password])
    if @user
      session[:current_user_id] = @user.id
      render json: { message: "Successfully Login"}
    else
      render json: { message: "Invalid" }
    end
  end

  def signup
    @user = User.find_by(email: params[:email])
    if @user
      render json: { message: "Already exist"}
    else
      @user = User.new(user_param)
      if @user.save
        render json: @user
      else
        render :new, status: "error"
      end
    end
  end

  def logout
    session.delete(:current_user_id)
    render json: { message: "Logout"}
  end

  def profile
    if session[:current_user_id] == nil
      render json: { message: "Login required" }
    else
      render json: User.find_by_id(session[:current_user_id])
    end
  end

  private
    def user_param
      params.require(:user).permit(:email, :password)
    end
end
