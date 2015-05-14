require 'rails_helper'

describe BasePresenter do
  let(:target) { double }
  let(:presenter) { BasePresenter.new target }

  it 'initializes the target' do
    expect(presenter.target).to eq target
  end

  it 'initializes the view helpers' do
    expect(presenter.v).to eq ActionController::Base.helpers
  end
end
