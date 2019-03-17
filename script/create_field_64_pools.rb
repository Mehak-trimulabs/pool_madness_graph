name_suffix = " NCAA March Madness Tournament"
previous_tournament_name = 1.year.ago.year.to_s + name_suffix
previous_tournament = Tournament.find_by name: previous_tournament_name

tournament = Tournament.create(
  name: Time.current.year.to_s + name_suffix,
  num_rounds: 6,
  tip_off: Time.parse("March 21, #{Time.current.year} 16:00 UTC").utc
)

team_name_hash = {
  Team::EAST => [
    "Duke",
    "Michigan St",
    "LSU",
    "Va Tech",
    "Miss St",
    "Maryland",
    "Louisville",
    "VCU",
    "UCF",
    "Minnesota",
    "PlayIn E11",
    "Liberty",
    "St Louis",
    "Yale",
    "Bradley",
    "PlayIn E16"
  ],
  Team::WEST => [
    "Gonzaga",
    "Michigan",
    "Texas Tech",
    "Florida St",
    "Marquette",
    "Buffalo",
    "Nevada",
    "Syracuse",
    "Baylor",
    "Florida",
    "PlayIn W11",
    "Murray St",
    "Vermont",
    "N Kentucky",
    "Montana",
    "PlayIn W16"
  ],
  Team::MIDWEST => [
    "N Carolina",
    "Kentucky",
    "Houston",
    "Kansas",
    "Auburn",
    "Iowa St",
    "Wofford",
    "Utah St",
    "Washington",
    "Seton Hall",
    "Ohio St",
    "New Mex St",
    "Northeastern",
    "Georgia St",
    "Abilene Chr",
    "Iona"
  ],
  Team::SOUTH => [
    "Virgina",
    "Tennessee",
    "Purdue",
    "Kansas St",
    "Wisconsin",
    "Villanova",
    "Cincinnati",
    "Ole Miss",
    "Oklahoma",
    "Iowa",
    "St Mary's",
    "Oregon",
    "UC Irvine",
    "Old Dominion",
    "Colgate",
    "G-Webb"
  ]
}

team_name_hash.each do |region, team_names|
  team_names.each_with_index do |name, i|
    tournament.teams.create region: region, seed: i + 1, name: name
  end
end

team_slot = tournament.teams.count

sort_order = [1, 16, 8, 9, 5, 12, 4, 13, 6, 11, 3, 14, 7, 10, 2, 15]

Team::REGIONS.each do |region|
  sort_order.each_slice(2) do |i, j|
    team_one = tournament.teams.find_by(region: region, seed: i)
    team_two = tournament.teams.find_by(region: region, seed: j)

    team_one.update(starting_slot: team_slot)
    team_two.update(starting_slot: team_slot + 1)

    team_slot += 2
  end
end

previous_tournament.pools.each do |previous_pool|
  pool = tournament.pools.create(name: previous_pool.name)

  previous_pool.pool_users.each do |pool_user|
    pool.pool_users.create(user_id: pool_user.user_id, role: pool_user.role)
  end
end
