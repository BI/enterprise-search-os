# provides the suggestions for the query builder

class QueryBuilderController < ApplicationController

  def suggest
    render :json =>  QueryBuilder.suggest(params)
  end

end
