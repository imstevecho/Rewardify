FactoryBot.define do
  factory :reward do
    sequence(:name) { |n| "Reward #{n}" }
    description { "This is a test reward description" }
    points_required { 100 }
    available { true }
  end
end
