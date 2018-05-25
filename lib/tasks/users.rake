namespace :users do
  desc 'Populate database with users'
  task populate: :environment do
    User.create!(name: 'Admin User',
                 email: 'admin@example.com',
                 password: 'password',
                 password_confirmation: 'password',
                 admin: true)

    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n + 1}@example.com"
      password = 'password'
      User.create!(name:  name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end
