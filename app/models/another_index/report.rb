# We use this model and its associations only for indexing.
module AnotherIndex
  class Report < Base

    include Elastics::ModelIndexer
    # we don't need syncing, since we are reindexing manually on a static database,
    # but just in case we would need real time syncing
    # elastics.sync self

    elastics.index = 'another_index'
    elastics.type  = 'report'

    include Incremental

  end
end
