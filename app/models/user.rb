# frozen_string_literal: true

class User < ApplicationRecord
  enum role: %i[user vip admin]
  COREVIST_DOMAIN = 'corevist.com'

  validates :email, :first_name, :last_name, :role, presence: true
  validates :password, confirmation: { case_sensitive: true }

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :omniauthable,
         omniauth_providers: [:google_oauth2]

  dragonfly_accessor :photo

  after_initialize :set_default_role, if: :new_record?

  def admin?
    role.to_sym == :admin
  end

  def user?
    role.to_sym == :user
  end

  def vip?
    role.to_sym == :vip
  end

  def name
    "#{first_name} #{last_name}".camelize
  end

  def token_expired?
    expires_at < Time.current.to_i
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider      = auth.provider
      user.uid           = auth.uid
      user.first_name    = auth.info.first_name
      user.email         = auth.info.email
      user.token         = auth.credentials.token
      user.refresh_token = auth.credentials.refresh_token
      user.expires_at    = Time.at(auth.credentials.expires_at)
      user.photo_url     = auth.info.image
      user.save!
    end
  end

  private

    def set_default_role
      self.role ||= :user
    end
end
