class PagesController < ApplicationController
  def graphql
    query_string = params[:query]

    result = GraphqlSchema.execute(
      query_string,
        variables: graphql_variables,
        context: {
          current_user: current_user,
          current_ability: current_ability,
          optics_agent: request.env[:optics_agent].try(:with_document, query_string)
        }
    )

    render json: result
  end

  private

  def graphql_variables
    variables = params[:variables]
    case variables
    when nil, ""
      {}
    when String
      JSON.parse(variables)
    else
      variables.to_unsafe_hash
    end
  end
end
