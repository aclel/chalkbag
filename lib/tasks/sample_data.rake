namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_climbs
    make_relationships
  end
end

def make_users
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_climbs
  users = User.all(limit: 6)
  50.times do
    content = Faker::Lorem.sentence(5)
    grade = rand(39-15) + 15
    users.each { |user| user.climbs.create!(content: content, grade: grade) }
  end
end

def make_relationships
  users = User.all
  user  = users.first
  followed_users = users[2..50]
  follows     = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  follows.each      { |follower| follower.follow!(user) }
end