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
end
