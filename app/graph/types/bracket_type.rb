module Types
  BracketType = GraphQL::ObjectType.define do
    name "Bracket"
    description "A bracket"
    interfaces [GraphQL::Relay::Node.interface]
    global_id_field :id

    field :name, !types.String
    field :owner, !UserType, property: :user
    field :editable, !types.Boolean do
      resolve ->(bracket, _args, context) { context[:current_ability].can?(:edit, bracket) }
    end
    field :tieBreaker, types.Int, property: :tie_breaker
    field :status, !types.String
    field :points, !types.Int
    field :possiblePoints, !types.Int, property: :possible_points
    field :finalFour, types[TeamType], property: :sorted_four

    field :bestPossibleFinish, !types.String do
      resolve ->(bracket, _args, _context) { bracket.best_possible < 3 ? (bracket.best_possible + 1).ordinalize : "-" }
    end

    field :eliminated, !types.Boolean do
      resolve ->(bracket, _args, _context) { bracket.best_possible > 2 }
    end

    field :pool, !PoolType

    field :gameDecisions, !types.String do
      resolve ->(bracket, _args, _context) { ::BitstringUtils.to_string(bracket.tree_decisions, 2**bracket.tournament.num_rounds) }
    end

    field :gameMask, !types.String do
      resolve ->(bracket, _args, _context) { ::BitstringUtils.to_string(bracket.tree_mask, 2**bracket.tournament.num_rounds) }
    end
  end
end
