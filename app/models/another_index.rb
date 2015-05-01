module AnotherIndex
  class Base < ActiveRecord::Base
    self.abstract_class = true
    establish_connection "another_index_#{Rails.env}"
  end
end
