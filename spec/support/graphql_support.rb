def execute_graph_query(query, variables = {}, context = {})
  current_user = context[:current_user]
  context = { current_user: current_user, current_ability: Ability.new(current_user) }.merge(context)
  variables = variables.deep_stringify_keys
  res = GraphqlSchema.execute(query, context: context, variables: variables)
  # Print any errors
  pp res if res["errors"]
  res
end
