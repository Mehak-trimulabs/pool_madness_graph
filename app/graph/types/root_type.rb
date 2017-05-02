module Types
  RootType = GraphQL::ObjectType.define do
    name "RootType"
    description "The query root of this schema"

    field :node do
      type GraphQL::Relay::Node.interface
      description "Fetches an object given its ID."
      argument :id, !types.ID, "ID of the object."

      resolve lambda { |_obj, args, context|
        object = ApplicationRecord.global_find(args[:id])
        object && context[:current_ability].can?(:read, object) ? object : nil
      }

      relay_node_field(true)
    end

    field :nodes do
      type !types[GraphQL::Relay::Node.interface]
      description("Fetches a list of objects given a list of IDs.")
      argument :ids, !types[!types.ID], "IDs of the objects."

      resolve lambda { |_obj, args, context|
        args[:ids].map do |id|
          object = ApplicationRecord.global_find(id)
          object && context[:current_ability].can?(:read, object) ? object : nil
        end
      }

      relay_nodes_field(true)
    end

    field :viewer do
      type !ViewerType
      resolve ->(_object, _args, _context) { Viewer.new }
    end
  end
end
