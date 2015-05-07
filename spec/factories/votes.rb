FactoryGirl.define do
  factory :vote do
    contestant_id { contestants_ids.sample }

    after :build do |vote, evaluator|
      vote.time = Time.now.strftime('%Y-%m-%d %H:00') unless vote.time.present?
    end

    factory :first_contestant_vote do
      contestant_id { contestants_ids.first }
    end

    factory :second_contestant_vote do
      contestant_id { contestants_ids.last }
    end
  end
end