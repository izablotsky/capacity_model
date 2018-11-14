# frozen_string_literal: true

class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    @users = User.all
    authorize User
  end

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def new
    @user = User.new
    authorize @user
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update_attributes(secure_params)
      redirect_to admin_users_path, notice: 'User updated.'
    else
      render :edit, alert: 'Unable to update user.'
    end
  end

  def create
    @user = User.new(secure_params)
    authorize @user

    if @user.save
      redirect_to admin_users_path, notice: 'User updated.'
    else
      render :new, alert: 'Unable to update user.'
    end
  end

  def destroy
    user = User.find(params[:id])
    authorize user
    user.destroy
    redirect_to admin_users_path, notice: 'User deleted.'
  end

  private

  def secure_params
    params.require(:user).permit(:first_name, :last_name, :email, :role, :password, :password_confirmation)
  end
end
