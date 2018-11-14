class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update]
  after_action :verify_authorized

  def show
    authorize :profile, :show?
  end

  def edit
    authorize :profile, :edit?
  end

  def update
    authorize :profile, :edit?

    if @profile.update(profile_params)
      redirect_to root_path, notice: 'Profile was successfully updated.'
    else
      render :edit
    end
  end

  private

    def set_profile
      @profile = User.find(params[:id])
    end

    def profile_params
      params.fetch(:user, {}).permit(:first_name, :last_name, :role, :password, :password_confirmation)
    end
end
