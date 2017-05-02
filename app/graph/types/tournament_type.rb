module Types
  TournamentType = GraphQL::ObjectType.define do
    name "Tournament"
    description "Single elimination bracket tournament"
    interfaces [GraphQL::Relay::Node.interface]

    global_id_field :id
    field :name, !types.String
    field :archived, !types.Boolean, property: :archived?
    field :gamesRemaining, !types.Int, property: :num_games_remaining

    field :tipOff, !types.String do
      resolve ->(tournament, _args, _context) { tournament.tip_off.iso8601 }
    end

    field :rounds, !types[RoundType]
    field :teams, !types[TeamType]

    field :gameDecisions, !types.String do
      resolve ->(tournament, _args, _context) { BitstringUtils.to_string(tournament.game_decisions, 2**tournament.num_rounds) }
    end
    field :gameMask, !types.String do
      resolve ->(tournament, _args, _context) { BitstringUtils.to_string(tournament.game_mask, 2**tournament.num_rounds) }
    end
  end
end
