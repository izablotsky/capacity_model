class ProfilePolicy < Struct.new(:user, :profile)
  def initialize(user, profile)
    @user = user
    @profile = profile
  end

  def show?
    true
  end

  def edit?
    true
  end
end
