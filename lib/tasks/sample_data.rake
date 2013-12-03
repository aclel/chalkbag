namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    users = User.all
    50.times do
      content = Faker::Lorem.sentence(5)
      grade = rand(25-15) + 15
      users.each { |user| user.climbs.create!(content: content, grade: grade) }
    end
  end
end