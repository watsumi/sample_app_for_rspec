FactoryBot.define do
  factory :task do
    title "pass"
    status 0
    association :user
  end
end
