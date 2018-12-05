# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string(255)
#  last_name              :string(255)
#  role                   :integer
#  provider               :string(255)
#  uid                    :string(255)
#  token                  :string(255)
#  expires_at             :integer
#  date_format            :string(255)
#  photo_uid              :string(255)
#  photo_name             :string(255)
#  refresh_token          :string(255)
#


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
