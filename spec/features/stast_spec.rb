require 'rails_helper'

# Needed to use login objects through Devise
include Warden::Test::Helpers
Warden.test_mode!

def login_admin
  login_as create(:admin), scope: :admin
end

feature 'Stats' do
  before do
    login_admin
  end

  scenario 'shows the total of votes and total per contestant', js: true do
    create_list :first_contestant_vote, 2, time: '2014-10-13 12:00'
    create :second_contestant_vote, time: '2014-10-13 13:00'

    visit admin_stats_path

    within '#total_general' do
      expect(page).to have_content '3'
    end

    within '#total_contestant_1' do
      expect(page).to have_content '2'
    end

    within '#total_contestant_2' do
      expect(page).to have_content '1'
    end

    within '#total_hourly' do
      expect(page).to have_content '2014-10-13 12:00: 2'
      expect(page).to have_content '2014-10-13 13:00: 1'
    end
  end
end
