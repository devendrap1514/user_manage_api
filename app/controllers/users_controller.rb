class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :suggest_login, unless: :is_login?, except: :login

  def is_login?
    session[:current_user_id] != nil
  end

  def suggest_login
    render json: { message: "Required Login" }
  end

  def index
    render json: User.all
  end

  def login
    @user = User.find_by(email: params[:email], password: params[:password])
    if is_login?
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
    session.delete(:current_user_id)
    render json: { message: "Logout" }
  end

  def profile
    render json: User.find_by_id(session[:current_user_id])
  end

  def update
    @user = User.find_by_id(session[:current_user_id])

    if @user.update_attribute(:password, params[:password]) && params[:password].present?
      render json: User.find_by_id(session[:current_user_id])
    else
      render json: { message: "Something went wrong" }
    end
  end

  private
    def user_param
      params.permit(:email, :password)
    end
end
