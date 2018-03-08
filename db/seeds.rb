DatabaseCleaner.clean_with :truncation

admin = User.create_with(name: ENV['ADMIN_NAME'].dup).find_or_create_by(email: ENV['ADMIN_EMAIL'].dup)
admin.update(admin: true)
puts "admin user: #{admin.name}"

user = User.create_with(name: 'Regular User').find_or_create_by(email: ENV['USER_EMAIL'])
puts "regular user: #{user.name}"

completed = FactoryBot.create(:tournament, :completed, name: "Completed Tourney")
final_four = FactoryBot.create(:tournament, :in_final_four, name: "Final Four Tourney")
two_rounds = FactoryBot.create(:tournament, :with_first_two_rounds_completed, name: "Two Rounds Completed Tourney")
not_started = FactoryBot.create(:tournament, :not_started, name: "Unstarted Tourney")

Tournament.all.each do |tournament|
  puts "creating 2 pools for tournament #{tournament.id}"
  FactoryBot.create_list(:pool, 2, tournament: tournament)
end

Pool.all.each do |pool|
  puts "creating admin for pool #{pool.id}"
  pool_user = FactoryBot.create(:pool_user, pool: pool)
  pool_user.admin!

  #adding known regular user to pool
  FactoryBot.create(:pool_user, pool: pool, user: user)

  puts "creating 5 regular users for pool #{pool.id}"
  FactoryBot.create_list(:pool_user, 5, pool: pool)

  pool.users.each do |user|
    puts "creating a completed bracket for pool/user #{pool.id}/#{user.id}"
    FactoryBot.create(:bracket, :completed, user: user, pool: pool)
  end
end

Bracket.all.each { |b| b.paid! }

puts "updating pool-admin and user email addresses"
PoolUser.admin.first.user.update!(email: "pool-admin@pool-madness.com")

puts "creating unpaid brackets"
not_started.pools.each do |pool|
  FactoryBot.create_list(:bracket, 2, :completed, user: user, pool: pool)
end

puts "creating championship brackets"
final_four.pools.each do |pool|
  pool.users.each { |user| FactoryBot.create(:bracket, :winning, user: user, pool: pool) }
end

Bracket.find_each do |bracket|
  bracket.calculate_points
  bracket.calculate_possible_points
end
