module QueryBuilder

  extend self

  # enables the templating system for the QueryBuilder module
  include Elastics::Templates

  # loads the app/elastics/query_builder.yml source file and defines the template methods in QueryBuilder
  elastics.load_source

  # wraps the #suggest method so it adds '.suggestion' dynamic type to whatever field we are querying the suggestion for
  # The multi_fields fields are date and number fields defined in config/elastics.yml (see the dynamic templates for the text type)
  # In practice if we search in the `.suggestion' type, we get a (not analyzed) string also for dates and numbers.
  elastics.wrap :suggest do |*params|
    vars = Elastics::Vars.new({:index => RequestStore.store[:searched_index],
                               :type  => Settings.query_builder_type },
                               *params)
    vars[:field] << '.suggestion' if Settings.suggestion_fields.include?(vars[:field])
    result = super vars
    result['suggestions']
  end

end
