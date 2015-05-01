module AnIndex
  class Base < ActiveRecord::Base
    self.abstract_class = true
    establish_connection "an_index_#{Rails.env}"
  end
end
