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

  # Message stating what other forms of voting on the contestant (phone, SMS, etc)
  def call_for_action
    msg = I18n.t 'presenters.contestant.call_for_action_html',
          contestant: target.name, ext: contact_extension

    v.content_tag :p, msg.html_safe, class: 'call-for-action'
  end

  private

  def contact_extension
    target.id.to_s.rjust 3, '0' # fill id with leading 0s
  end
end
