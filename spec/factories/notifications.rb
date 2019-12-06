FactoryBot.define do
  factory :notification do
    source { "MyString" }
    source_id { 1 }
    actor { nil }
    notifier { nil }
    read_status { false }
  end
end
