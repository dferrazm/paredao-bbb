class ContestantPresenter < BasePresenter
  def id
    target.id
  end

  def name
    target.name
  end

  def avatar
    v.content_tag :div, class: :avatar, style: "background-image: url('#{target.avatar_path}')" do
      v.content_tag :div, nil, class: 'inner'
    end
  end

  def call_for_action
    v.content_tag :p, class: 'call-for-action' do
      I18n.t('presenters.contestant.call_for_action_html', contestant: target.id).html_safe
    end
  end
end
