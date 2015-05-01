module CountCache

  extend self

  COUNTS_KEY = "#{Elastics::Configuration.app_id}:counts"

  def set
    counts             = {}

    counts['texts']    = Elastics.count(:index => 'an_index',       :type => 'text')['count']    if Elastics.exist?(:index => 'an_index')
    counts['projects'] = Elastics.count(:index => 'an_index',       :type => 'project')['count'] if Elastics.exist?(:index => 'an_index')
    counts['reports']  = Elastics.count(:index => 'an other_index', :type => 'report')['count']  if Elastics.exist?(:index => 'another_index')
    counts['website']  = Elastics.count(:index => 'website',        :type => nil)['count']       if Elastics.exist?(:index => 'website')

    Redis.current.set COUNTS_KEY, MultiJson.encode(counts)
  end

  set

  def get(key)
    counts = MultiJson.decode(Redis.current.get(COUNTS_KEY))
    c = counts[key.to_s]
    c && c.to_i || 0
  end

end
