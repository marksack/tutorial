namespace :users do
  desc 'Populate database with users'
  task populate: :environment do
    User.create!(name: 'Admin User',
                 email: 'admin@example.com',
                 password: 'password',
                 password_confirmation: 'password',
                 admin: true,
                 activated: true,
                 activated_at: Time.zone.now)

    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n + 1}@example.com"
      password = 'password'
      User.create!(name:  name,
                   email: email,
                   password: password,
                   password_confirmation: password,
                   activated: true,
                   activated_at: Time.zone.now)
    end
  end

  desc 'Add following relationships'
  task following_relationships: :environment do
    users = User.all
    user  = users.first
    following = users[2..50]
    followers = users[3..40]
    following.each { |followed| user.follow(followed) }
    followers.each { |follower| follower.follow(user) }
  end
end
