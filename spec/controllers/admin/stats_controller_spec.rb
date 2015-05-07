require 'rails_helper'

describe Admin::StatsController do
  context 'when admin not logged in' do
    %w(index).each do |action|
      it "requires authentication for :#{action}" do
        get action.to_sym
        expect(response).to redirect_to new_admin_session_path
      end
    end
  end

  context 'when user logged in' do
    before do
      sign_in create(:admin)
    end

    describe 'GET index' do
      before do
        get :index
      end

      it 'assigns @total' do
        expect(assigns :total).to_not be_nil
      end

      it 'assigns @stats' do
        expect(assigns :stats).to_not be_nil
      end

      it 'renders the :index template' do
        expect(response).to render_template :index
      end
    end
  end
end
