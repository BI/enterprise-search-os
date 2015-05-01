module AnIndex
  module Search

    # enables the templating system for Search
    include Elastics::Templates

    # sets the default results per page
    elastics.variables.deep_merge! :params => {:size => Settings.an_index.results.per_page}

    # loads the app/elastics/es.yml source file and defines the template methods in Search
    elastics.load_search_source Rails.root.join('app/elastics/an_index/search.yml').to_s

    elastics.index = 'an_index'

    # default type used when we don't pass a specific :type with the variables
    elastics.type = 'text'

    # enables the Search scopes
    include Elastics::Scopes

    extend self

    # We need to parse the params and build the variables to pass to the search templates
    # the bang character at the end of a key, creates the keys if it is missing
    # the try_delete(...).each will silently do nothing if there is nothing to delete
    def params_to_vars(*params)
      vars = Elastics::Vars.new(*params)
      searched_index = vars.delete(:searched_index)
      vars[:index] ||= searched_index
      vars.try_delete(:facets).each do |name, terms|
        terms.each do |term|
          vars[:_filter_facet_terms!] << { :facet_hash => { name => term } }
        end
      end
      unless vars[:mlt_id].blank?
        if (mlt_doc = Search.find vars[:mlt_id])
          vars[:like_text]   = mlt_doc.field_two
          vars[:like_fields] = %w[field_two]
          # storing into the vars make it accessible from @result.variables[:mlt_doc]
          # so we don't need to query twice
          # the '=' character at the end of the key sets :mlt_doc and preserves it from
          # being transformed in a Elastics::Struct::Hash (which would remove the extended methods)
          vars[:mlt_doc=] = mlt_doc
        end
      end
      vars.delete(:q) if vars[:q].blank?
      vars
    end

    # Wrapper for the template methods that use the same params structure
    # it redefines each method with the block.
    # in practice we process and modify the params with the #params_to_vars method
    # before calling the listed methods
    elastics.wrap :search, :search_facets, :search_projects do |*params|
      super params_to_vars(*params)
    end

    def get_result_ids(*params)
      get_list_for :search, *params
    end

    def get_accession_numbers(*params)
      get_list_for :search_projects, *params
    end

    def search_in_batches(*params, &block)
      elastics.scan_search(:search, params_to_vars(*params), &block)
    end

    def query_feedback(params)
      [count(:search, params), count(:search_projects, params)]
    end

  private

    def get_list_for(query, *params)
      list   = []
      elastics.scan_search(query, params_to_vars(*params), :params=>{ :fields => '', :size => 250 }) do |result|
        list << result.collection.map do |doc|
                  doc['_id']
                end
      end
      list.flatten
    end

  end
end
