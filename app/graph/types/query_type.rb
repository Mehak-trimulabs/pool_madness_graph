module Types
  QueryType = GraphQL::ObjectType.define do
    name "Query"
    description "The query root of this schema"

    field :node, (GraphQL::Relay::Node.field do
      resolve lambda { |_obj, args, context|
        object = ApplicationRecord.global_find(args[:id])
        object && context[:current_ability].can?(:read, object) ? object : nil
      }
    end)

    field :nodes, (GraphQL::Relay::Node.plural_field do
      resolve lambda { |_obj, args, context|
        args[:ids].map do |id|
          object = ApplicationRecord.global_find(id)
          object && context[:current_ability].can?(:read, object) ? object : nil
        end
      }
    end)

    field :viewer do
      type !ViewerType
      resolve ->(_object, _args, _context) { Viewer.new }
    end
  end
end
