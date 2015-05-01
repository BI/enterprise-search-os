class Settings < Settingslogic
  source Rails.root.join('config', 'settings.yml')
  namespace Rails.env

  def incremental
    ENV['INCREMENTAL'] == 'true' || ENV['INCREMENTAL'] == '1' || false
  end

  class << self

    # current_app methods
    # these methods automatically load the inner key/value
    delegate :facets,
             :facets_with_description,
             :suggestion_fields,
             :single_value_fields,
             :facet_panel,
             :query_fields,
             :export_fields,
             :query_builder_type,
             :css_metric,
             :results,
             :to => 'send(RequestStore.store[:searched_index].to_sym)'

  end

end
