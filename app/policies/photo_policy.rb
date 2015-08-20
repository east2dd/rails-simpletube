class PhotoPolicy
  attr_reader :user, :photo

  def initialize(user, photo)
    @user = user
    @photo = photo
  end

  def update?
    @photo.user == user or (user && user.admin?)
  end

  def destroy?
    @photo.user == user or (user && user.admin?)
  end
end