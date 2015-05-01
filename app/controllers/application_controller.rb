class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action do
    searched_index                      = params[:searched_index].blank? ? 'an_index' : params[:searched_index]
    params[:searched_index]             = searched_index
    RequestStore.store[:searched_index] = searched_index
    search_class                        = "#{searched_index.capitalize}::Search"
    RequestStore.store[:search_class]   = search_class.constantize rescue nil
    self.class.layout = params[:searched_index]
  end

  helper_method :json_params

  def json_params
    # cleanup params for saved_search
    Elastics::Prunable.prune_blanks(params.slice(:searched_index,
                                                 :q,
                                                 :facets,
                                                 :advanced_search_flag,
                                                 :advanced_search_status,
                                                 :mlt_id)).to_json
  end

  # shortcut for controllers
  def search_class
    RequestStore.store[:search_class]
  end

end
