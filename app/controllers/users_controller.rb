class UsersController < ApplicationController
  # protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def index
    render json: User.all
  end

  def login
    @user = User.find_by(email: params[:email], password: params[:password])
    if session[:current_user_id] != nil
      render json: { message: "Already login" }
    elsif @user
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
        render json: { message: "Invalid" }
      end
    end
  end

  def logout
    if session[:current_user_id] != nil
      session.delete(:current_user_id)
      render json: { message: "Logout"}
    else
      render json: { message: "Login required" }
    end
  end

  def profile
    if session[:current_user_id] == nil
      render json: { message: "Login required" }
    else
      render json: User.find_by_id(session[:current_user_id])
    end
  end

  def update
    if session[:current_user_id] != nil
      @user = User.find_by_id(session[:current_user_id])

      if @user.update_attribute(:password, params[:password]) && params[:password].present?
        render json: User.find_by_id(session[:current_user_id])
      else
        render json: { message: "Something went wrong" }
      end
    else
      render json: { message: "Login required" }
    end
  end

  private
    def user_param
      params.permit(:email, :password)
    end
end
