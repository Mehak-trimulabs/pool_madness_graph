GraphqlSchema = GraphQL::Schema.define do
  query ::Types::RootType
  mutation ::Mutations::RootMutation

  id_from_object ->(object, _type_definition, _query_ctx) { object.id }

  object_from_id ->(id, _query_ctx) { ApplicationRecord.global_find(id) }

  resolve_type ->(object, _context) { object.graph_type }
end

GraphqlSchema.rescue_from(ActiveRecord::RecordInvalid) do |error|
  error.record.errors.each_with_object({}) { |(attr, msg), obj| obj[attr.to_s] = Array(msg).uniq }.to_json
end
