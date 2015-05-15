require 'rails_helper'

feature 'Votes' do
  before do
    clear_redis
  end

  feature 'Perform' do
    contestants_ids.each do |contestant|
      scenario "creates a vote to the contestant #{contestant}", js: true do
        Poll.current.start Time.now.tomorrow

        visit votes_path
        find("#contestant_#{contestant}_container .avatar").trigger 'click'
        click_button I18n.t('votes.index.actions.submit_vote')

        expect(page).to have_content I18n.t('votes.create.success_raw')

        Cache::Votes.flush_all

        visit result_votes_path

        within "#contestant_#{contestant}_container" do
          expect(page).to have_content '100%'
        end

        Poll.current.stop
      end
    end
  end

  feature 'Result' do
    before do
      create_list :lais_vote, 1
      create_list :yuri_vote, 2

      Cache::Base.init
    end

    scenario 'opens up the result page showing the votes percentage for each contestant', js: true do
      visit result_votes_path

      within '#contestant_1_container' do
        expect(page).to have_content '33%'
      end

      within '#contestant_2_container' do
        expect(page).to have_content '67%'
      end
    end
  end
end
