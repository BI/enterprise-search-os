Elastics::Configuration.configure do |c|

  c.elastics_models += %w[ AnIndex::Project AnotherIndex::Report ]
  c.elastics_active_models += %w[ WebsiteContent ]
  c.result_extenders << EsResultExtender
  # the live app doesn't change the index, so we don't need any on_stop_indexing proc
  c.on_stop_indexing = false
  c.app_id = "enterprise_search-#{Rails.env}"
  c.optimize_indexing = false

end
