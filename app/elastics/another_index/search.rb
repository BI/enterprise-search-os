module AnotherIndex
  module Search

    # enables the templating system for Search
    include Elastics::Templates

    # sets the default results per page
    elastics.variables.deep_merge! :params => {:size => Settings.another_index.results.per_page}

    # loads the app/elastics/es.yml source file and defines the template methods in Search
    elastics.load_search_source Rails.root.join('app/elastics/another_index/search.yml').to_s

    elastics.index = 'another_index'

    # default type used when we don't pass a specific :type with the variables
    elastics.type = 'report'


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
      vars.try_delete(:facets).each do |name, items|
        items.each do |item|
          if item =~ /^\d+$/
            vars[:_filter_facet_ranges!] << { :range_field => name,
                                              :facet_hash  => send(:"#{name}_range_hash", item) }
          else
            vars[:_filter_facet_terms!] << { :facet_hash => { name => item } }
          end
        end
      end
      vars[:report_due_ranges] = report_due_ranges
      unless vars[:sort].blank?
        f,d = vars[:sort].split(',')
        vars[:sort] = {f => d}
      end
      vars.delete(:q) if vars[:q].blank?
      vars
    end

    # Wrapper for the template methods that use the same params structure
    # it redefines each method with the block.
    # in practice we process and modify the params with the #params_to_vars method
    # before calling the listed methods
    elastics.wrap :search, :search_facets do |*params|
      super params_to_vars(*params)
    end


    def search_in_batches(*params, &block)
      elastics.scan_search(:search, params_to_vars(*params), &block)
    end

    def query_feedback(params)
      count(:search, params)
    end

  private

    def get_list_for(query, *params)
      list = []
      elastics.scan_search(query, params_to_vars(*params), :params=>{ :fields => '', :size => 250 }) do |result|
        list << result.collection.map(&:_id)
      end
      list.flatten
    end


    def report_due_ranges
      [ { :to => msecs_in(0) },
        { :from => msecs_in(0), :to => msecs_in(30) },
        { :from => msecs_in(30), :to => msecs_in(60) },
        { :from => msecs_in(60), :to => msecs_in(90) } ]
    end

    def report_due_range_hash(i)
      r    = report_due_ranges[i.to_i]
      hash = { :lte => msecs_to_date(r[:to]) }
      hash[:gte] = msecs_to_date(r[:from]) unless r[:from].blank?
      hash
    end

    def msecs_in(days)
      (Time.now.to_f + (days * 24 * 60 * 60)) * 1000
    end

    def msecs_to_date(msecs)
      Time.at(msecs/1000).to_date.to_s
    end

  end
end
