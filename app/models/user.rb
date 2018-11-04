# frozen_string_literal: true

class User < ApplicationRecord
  enum role: %i[user vip admin]
  COREVIST_DOMAIN = 'corevist.com'

  after_initialize :set_default_role, if: :new_record?

  devise :database_authenticatable,:recoverable, :rememberable, :trackable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  dragonfly_accessor :photo

  def set_default_role
    self.role ||= :user
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.first_name = auth.info.first_name
      user.email = auth.info.email
      user.token = auth.credentials.token
      user.expires_at = Time.at(auth.credentials.expires_at)
      user.photo_url = auth.info.image
      user.save!
    end
  end

  def name
    "#{first_name} #{last_name}".camelize
  end
end
