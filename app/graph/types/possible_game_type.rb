module Types
  PossibleGameType = GraphQL::ObjectType.define do
    name "PossibleGame"
    description "A possible outcome of a game"

    field :slot, !types.Int

    field :previousSlotOne, types.Int, property: :left_position
    field :previousSlotTwo, types.Int, property: :right_position

    field :nextGameSlot, types.Int, property: :next_game_slot
    field :nextGamePosition, types.Int, property: :next_slot # 1 or 2

    field :roundNumber, !types.Int, property: :round_number
    field :region, types.String

    field :firstTeam, TeamType, property: :first_team
    field :secondTeam, TeamType, property: :second_team
    field :winningTeam, TeamType, property: :team
    field :losingTeam, TeamType, property: :loser
  end
end
