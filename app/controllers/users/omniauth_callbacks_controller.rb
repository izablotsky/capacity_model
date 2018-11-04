require 'mail'

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  COREVIST_DOMAIN = 'corevist.com'.freeze

  before_action :check_domain, only: :google_oauth2

  def google_oauth2
    @user = User.from_omniauth(auth_params)
    if @user.persisted?
      flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: 'Google')
      sign_in_and_redirect(@user, event: :authentication)
    else
      session['devise.google_data'] = auth_params.except(:extra)
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  private

  def auth_params
    request.env['omniauth.auth']
  end

  def check_domain
    email = Mail::Address.new(auth_params.info.email)
    if email.domain != COREVIST_DOMAIN
      render file: 'public/403.html', status: 403, layout: false
    end
  end
end
