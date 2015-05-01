require 'crawler'

def config(task)
  Elastics::Conf.app_id = "#{Elastics::Conf.app_id}-#{task}"
  unless Rails.env.dd?
    Elastics::Conf.logger.info "Setting Logger level to 'Logger::ERROR' from task index:#{task}"
    Elastics::Conf.logger.level = Logger::ERROR
    Elastics::Conf.logger.log_to_stderr = false
  end
end

namespace :index do

  desc 'Index an_index'
  task :an_index => :environment do
    config 'an_index'
    ensure_indices = 'an_index' if Settings.incremental
    Elastics::LiveReindex.reindex_models(:models         => [ AnIndex::Project ],
                                         :batch_size     => 250,
                                         :ensure_indices => ensure_indices)
    CountCache.set
    # the settings reflect the index, so restart the app in case you change any setting
  end


  desc 'Index another_index'
  task :another_index => :environment do
    config 'another_index'
    ensure_indices = 'another_index' if Settings.incremental
    Elastics::LiveReindex.reindex_models(:models         => [ AnotherIndex::Report ],
                                         :batch_size     => 250,
                                         :ensure_indices => ensure_indices)
    CountCache.set
    # the settings reflect the index, so restart the app in case you change any setting
  end

  desc 'Index the website content'
  task :website  => :environment do
    config 'website'
    Elastics::LiveReindex.reindex do |conf|
      # we don't need any on_each_change block as we do it all in the on_reindex block
      conf.on_reindex do
        Crawler.crawl_and_index_website(ENV['MAX'])
      end
    end
    CountCache.set
  end

end
