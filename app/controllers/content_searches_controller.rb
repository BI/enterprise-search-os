# searches the content indices: reeis, areera and cris

class ContentSearchesController < ApplicationController

  def search
    @search_path = content_search_path(:searched_index => params[:searched_index])
    send params[:searched_index].to_sym
  end

private

  # example index "one"... add as many indices as needed
  def website
    @search_title = 'Website Search'
    search_content OneContent
  end

  def search_content(content_class)
    @results = content_class.searchable(params[:q]).all(:page => params[:page]) unless params[:q].blank?
    render 'search'
  end

end
