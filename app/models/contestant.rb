class Contestant < ActiveRecord::Base
  has_many :votes, dependent: :destroy
  mount_uploader :avatar, AvatarUploader

  def self.avatar_path(id)
    "/uploads/#{id}/avatar.png"
  end

  def avatar_path
    self.class.avatar_path id
  end
end
