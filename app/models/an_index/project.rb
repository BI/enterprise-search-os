module AnIndex
  class Project < Base

    include Elastics::ModelIndexer
    # we don't need syncing, since we are reindexing manually on a static database,
    # but just in case we would need real time syncing
    # elastics.sync self

    elastics.index = 'an_index'
    elastics.type  = 'project'

    include Incremental

  end
end
