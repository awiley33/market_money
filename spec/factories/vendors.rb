FactoryBot.define do
  factory :vendor do
      name { "#{Faker::Hipster.word} #{Faker::Company.industry}" }
      description { "#{Faker::Hipster.sentence}" }
      contact_name { "#{Faker::Name.name}" }
      contact_phone { "#{Faker::PhoneNumber.cell_phone}" }
      credit_accepted { Faker::Boolean.boolean }
  end
end