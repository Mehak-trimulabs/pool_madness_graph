module Types
  PossibilityType = GraphQL::ObjectType.define do
    name "Possibility"
    description "A possible result of a pool"

    field :championships, types[PossibleGameType]
    field :firstPlace, types[BracketType] do
      resolve ->(possibility, _args, _context) { possibility.best_brackets.first }
    end
    field :secondPlace, types[BracketType] do
      resolve ->(possibility, _args, _context) { possibility.best_brackets.second }
    end
    field :thirdPlace, types[BracketType] do
      resolve ->(possibility, _args, _context) { possibility.best_brackets.third }
    end
  end
end
