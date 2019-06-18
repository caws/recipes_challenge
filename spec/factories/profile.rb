FactoryBot.define do
  factory :profile do

    title {Faker::TvShows::TheITCrowd.character}
    description {Faker::TvShows::TheITCrowd.quote}

    before :create do |profile|
      profile.users << FactoryBot.build_list(:user, rand(1..10), profile: nil)
    end

    after :build do |profile|
      profile.users << FactoryBot.build_list(:user, rand(1..10), profile: nil)
    end

  end
end
