# This module defines the elastics_in_batches method that is used to index the DB
# It uses the modified_after scope, which will collect only the modified records
# since the last timestamp (got from the index name)
module Incremental
  extend ActiveSupport::Concern

  included do

    scope :modified_after, lambda { |timestamp_datetime=nil|
                                    if timestamp_datetime.nil?
                                      all
                                    else
                                      where('updated_at > :t OR created_at > :t', { :t => timestamp_datetime })
                                    end
                                  }

    scope :not_deleted, lambda { |timestamp_datetime=nil|
                                 if timestamp_datetime.nil?
                                   where('deleted_at IS NULL')
                                 else
                                   where('deleted_at IS NULL OR deleted_at < :t', {:t => timestamp_datetime})
                                 end
                               }
    scope :includes_related, lambda { all }

    def self.elastics_in_batches(options={},&block)
      if Settings.incremental
        # get the full index name
        index = Elastics.get_settings(:index => elastics.index).keys.first
        # get the index timestamp
        timestamp = Elastics::LiveReindex.get_timestamp_from_index(index)
        includes_related.modified_after(timestamp).find_in_batches(options, &block)
      else
        includes_related.not_deleted.find_in_batches(options, &block)
      end
    end

  end
end
