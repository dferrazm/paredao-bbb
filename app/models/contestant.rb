class Contestant < ActiveRecord::Base
  after_destroy :destroy_votes
  mount_uploader :avatar, AvatarUploader

  def self.cached_ids
    ContestantsStore.ids
  end

  def self.avatar_path(id)
    "/uploads/#{id}/avatar.png"
  end

  def avatar_path
    self.class.avatar_path id
  end

  private

  def destroy_votes
  	Vote.where(contestant_id: id).delete_all
  end
end