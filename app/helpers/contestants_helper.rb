module ContestantsHelper
  def contestant_avatar(id)
    content_tag :div, class: :avatar, style: "background-image: url('#{Contestant.avatar_path id}')" do
      yield if block_given?
    end
  end
end