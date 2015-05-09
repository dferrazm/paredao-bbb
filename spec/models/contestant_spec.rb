require 'rails_helper'

describe Contestant do  
  describe 'avatar_path' do
    it 'returns the avatar path fora given contestant id' do
      expect(Contestant.avatar_path 2).to eq '/uploads/2/avatar.png'
    end
  end

  context 'instance methods' do
    describe 'avatar_path' do
      it 'returns the avatar path fora given contestant id' do
        c = create :contestant, id: 23
        expect(c.avatar_path).to eq '/uploads/23/avatar.png'
      end
    end
  end
end
