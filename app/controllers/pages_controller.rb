class PagesController < ApplicationController
  def graphql
    query_string = params[:query]
    query_variables = params[:variables].to_unsafe_hash

    result = GraphqlSchema.execute(
      query_string,
        variables: query_variables,
        context: {
          current_user: current_user,
          current_ability: current_ability,
          optics_agent: request.env[:optics_agent].try(:with_document, query_string)
        }
    )

    render json: result
  end
end
