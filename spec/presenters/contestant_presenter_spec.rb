require 'rails_helper'

describe ContestantPresenter do
  let(:target) { double id: 42, name: 'John Doe', avatar_path: '/path/to/avatar' }
  let(:contestant) { ContestantPresenter.new target }

  describe 'id' do
    it 'returns the target id' do
      expect(contestant.id).to eq 42
    end
  end

  describe 'name' do
    it 'returns the target name' do
      expect(contestant.name).to eq 'John Doe'
    end
  end

  describe 'avatar' do
    it 'builds the avatar html including the avatar path' do
      expect(contestant.avatar).to include '/path/to/avatar'
    end
  end

  describe 'call_for_action' do
    it 'builds the call for action message for the target' do
      expected = I18n.t 'presenters.contestant.call_for_action_html', contestant: 42
      expect(contestant.call_for_action).to include expected
    end
  end
end
