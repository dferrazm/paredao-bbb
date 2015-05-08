require 'rails_helper'

feature 'Votes' do
  before do
    clear_redis
  end

  feature 'Perform' do
    contestants_ids.each do |contestant|
      scenario "creates a vote to the contestant #{contestant}", js: true do
        visit votes_path
        find("#contestant_#{contestant}_container .avatar").trigger 'click'
        click_button I18n.t('votes.index.submit_vote')

        expect(page).to have_content I18n.t('votes.create.success_raw')

        VoteStore.flush_all

        visit result_votes_path

        within "#contestant_#{contestant}_container" do
          expect(page).to have_content '100%'
        end
      end
    end
  end

  feature 'Result' do
    before do
      allow(ContestantsStore).to receive(:votes).with('1') { 7 } # 35 %
      allow(ContestantsStore).to receive(:votes).with('2') { 13 } # 65 %
    end

    scenario 'opens up the result page showing the votes percentage for each contestant', js: true do
      visit result_votes_path
      within '#contestant_1_container' do
        expect(page).to have_content '35%'
      end

      within '#contestant_2_container' do
        expect(page).to have_content '65%'
      end
    end
  end
end
