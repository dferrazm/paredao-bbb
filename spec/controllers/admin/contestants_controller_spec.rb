require 'rails_helper'

describe Admin::ContestantsController do
  before do
    sign_in create(:admin_user)
  end

  context 'with a poll running' do
    let(:perform_new) { get :new }
    let(:perform_create) { post :create }
    let(:perform_destroy) { delete :destroy, id: 1 }

    before do
      allow(Poll).to receive(:finished?) { false }
    end

    shared_examples 'redirect_to_index' do |method|
      describe method do
        it 'redirects to index' do
          send :"perform_#{method}"
          expect(response).to redirect_to action: :index
        end
      end
    end

    include_examples 'redirect_to_index', 'new'
    include_examples 'redirect_to_index', 'create'
    include_examples 'redirect_to_index', 'destroy'
  end
end
