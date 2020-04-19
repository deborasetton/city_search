FactoryBot.define do
  factory :api_client do
    sequence :name do |n|
      "api_client_#{n}"
    end
  end
end
