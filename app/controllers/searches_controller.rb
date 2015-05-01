# searches the gsa index, show a saved search or result

class SearchesController < ApplicationController

  def search_facets
    @results      = search_class.search_facets(params)
    @search_path  = params[:advanced_search_flag] == 'advanced' ? advanced_search_path(:searched_index => params[:searched_index]) : root_path(:searched_index => params[:searched_index])
  end

  def query_feedback
    @query_feedback = search_class.query_feedback(params)
  rescue Elastics::HttpError => e
    # the SearchPhaseExecutionException means that the query entered in the query field generated some error
    # hence we silence this error, and use the @query_feedback.blank? condition in the query_feedback.js.erb
    raise unless e.to_hash['error'] =~ /^SearchPhaseExecutionException/
  end

end
