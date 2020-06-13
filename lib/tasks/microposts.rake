namespace :microposts do
  desc 'Add microposts to some of the users'
  task add_to_some_users: :environment do
    users = User.order(:created_at).take(6)
    50.times do
      content = Faker::Lorem.sentence(word_count: 5)
      users.each { |user| user.microposts.create!(content: content) }
    end
  end
end
