# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  role                   :integer          default("master"), not null
#  gender                 :integer          default("male"), not null
#  nick_name              :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  first_name             :string
#  last_name              :string
#  messenger_id           :string
#

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    gender { Random.rand(2) }
    email { Faker::Internet.user_name + '@iss.nthu.edu.tw' }
    password { 'abcd1234' }
    password_confirmation { 'abcd1234' }
    nick_name { Faker::FunnyName.name }
    role { 0 }
    messenger_id { Faker::Internet.password(10) }

    trait :admin do
      admin { true }
    end

    trait :confirmed do
      after(:create) do |u|
        u.confirm
      end
    end
  end
end
