module EsResultExtender

  def self.should_extend?(result)
    result.response.url =~ /\b_search\b/ && result['hits'] && result['facets']
  end

  # adds a description field to each facet term
  def facets
    @facets ||= ( desc = descriptions
                  Settings.facets_with_description.each do |name|
                    self['facets'][name]['terms'].each do |t|
                      t['description'] = desc[t['term']]
                    end
                  end
                  self['facets'] )
  end

  # we can use the descriptions hash to lookup the description for each facet term
  def descriptions
    @descriptions ||= ( ids = Settings.facets_with_description.map do |name|
                          self['facets'][name]['terms'].map{|f| f['term']}
                        end.flatten
                        return {} if ids.empty?
                        descriptions = Elastics.multi_get :index => RequestStore.store[:searched_index], :type => 'description', :ids  => ids
                        desc = {}
                        descriptions['docs'].each do |d|
                          desc[d['_id']] = d['_source']['description']
                        end
                        desc )
  end

end
