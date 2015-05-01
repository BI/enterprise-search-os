module SearchesHelper


  def params_dup
    Marshal.load(Marshal.dump(params))
  end


  def facet_names
    @facet_names ||= Settings.facets.keys
  end


  def facet_label(name)
    Settings.facets[name]['label']
  end


  def selected_facet_items
    @selected_facet_items ||= ( sel = { }
                                if params.has_key?(:facets)
                                  facet_names.each do |name|
                                    sel[name] = params[:facets][name] unless params[:facets][name].blank?
                                  end
                                end
                                sel )
  end

  def facet_selected?(name)
    !selected_facet_items[name].blank?
  end

  def facet_item_selected?(name, item)
    selected_facet_items[name] && selected_facet_items[name].include?(item.to_s) # to_s needed because selected_facet_items come from params
  end

  def facet_item_label(name, item)
    item  = item.to_s
    label = if Settings.facets[name]['range_labels'].blank?
              descr = @results.descriptions[item]
              descr.blank? ? "#{item}" : "[#{item}] #{descr}"
            else
              Settings.facets[name]['range_labels'][item.to_i]
            end
    label.truncate(60)
  end


  def facet_item_title(prefix, name, item)
    "#{prefix} #{facet_label(name)}: #{facet_item_label(name, item)}"
  end


  def project_url(no)
    "#{Settings.cris_start_url}#{no.to_i}.php"
  end


  # returns the highlighted facet terms
  # this method highlights the content, not using the elasticsearch highlight
  def highlighted_facet_terms(facet_terms)
    facet_terms = Array.wrap(facet_terms)
    unless params[:q].blank?
      facet_terms.map! do |f|
        params[:q] =~ /#{Regexp.escape(f.to_s)}/ ? "<em>#{h(f.to_s)}</em>" : f
      end
    end
    facet_terms.join(', ').html_safe
  end


  def should_skip_facets(result_facet)
    case result_facet['_type']
    when 'terms'
      result_facet['total'] == 0
    when 'range'
      result_facet['ranges'].all? {|r| r['count'] == 0 }
    end
  end

  def sort_items(name)
    if params[:sort].blank?
      ["#{name},asc", "&#8597;"]
    else
      sorted_by, direction = params[:sort].split(',')
      if name == sorted_by
        case direction
        when 'asc'   then ["#{name},desc", "&#8593;"]
        when 'desc'  then ['', "&#8595;"]
        end
      else
        ["#{name},asc", "&#8597;"]
      end
    end
  end

  def sorted_class(name)
    sorted_by, direction = params[:sort].split(',')
    name == sorted_by ? 'sorted' : 'unsorted'
  end

  def custom_sort(custom_order, unordered)
    unordered.sort do |a, b|
      (custom_order.index(a['term']) || -1) <=> (custom_order.index(b['term']) || -1)
    end
  end

  def results_label(count)
    pluralize(number_with_delimiter(count), (params[:facets][:document_type].try(:first)) || 'Result')
  end

end
