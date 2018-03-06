class GraphqlController < ApplicationController
  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    context = {
      current_user: current_user,
      current_ability: current_ability,
      optics_agent: request.env[:optics_agent].try(:with_document, query)
    }
    result = GraphqlSchema.execute(query, variables: variables, context: context)

    logger.info("Graph Result")
    logger.info(result.to_h)

    render json: result
  end

  private

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      if ambiguous_param.present?
        ensure_hash(JSON.parse(ambiguous_param))
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end
end
