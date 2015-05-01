require 'active_support/json/encoding'
class BigDecimal
  def as_json(options = nil)
    self
  end
end
