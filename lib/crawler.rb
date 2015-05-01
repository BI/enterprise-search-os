require 'anemone'

module Crawler

  # custom MySQL anemone storage
  # we use mysql in order to reduce the memory requirement of other built-in storages
  class MySqlStorage

    def initialize(reset=true)
      CrawledPage.destroy_all if reset
    end

    def [](url)
      crawled = crawled(url)
      crawled.page if crawled
    end

    def []=(url, page)
      crawled = crawled(url)
      if crawled
        crawled.update_attribute :page, page
      else
        crawled = CrawledPage.create :url => url, :page => page
      end
      crawled.page
    end

    def delete(url)
      crawled = crawled(url)
      return unless crawled
      crawled.destroy
      crawled.page
    end

    def chunked_each(opts={})
      opts = {:batch_size => 100}.merge(opts)
      CrawledPage.find_in_batches(opts) do |batch|
        batch.each{ |crawled| yield crawled.url, crawled.page }
      end
    end

    alias_method :each, :chunked_each

    def merge!(hash)
      hash.each { |key, value| self[key] = value }
      self
    end

    def size
      CrawledPage.count
    end

    def keys
      CrawledPage.all.map(&:url)
    end

    def has_key?(url)
      !!crawled(url)
    end

    def close

    end

  private

    def crawled(url)
      CrawledPage.where(:url => url).first
    end

  end

  extend self

  def crawl_and_index_website(max=nil)
    puts "Crawling Website Content:"
    start_url     = Settings.website_start_url
    indexed_pages = 0
    Anemone.crawl( start_url, :discard_page_bodies => true, :verbose => true ) do |anemone|
      anemone.storage = MySqlStorage.new
      # crawl only the start_url dir
      anemone.focus_crawl do |page|
        page.links.delete_if do |link|
          link.to_s !~ %r{^#{start_url}} || link.to_s =~ %r{^#{start_url}/?\?}
        end
      end
      anemone.on_every_page do |page|
        if page.code == 200 && page.body.length > 0
          WebsiteContent.create :url        => page.url.to_s,
                                :attachment => Base64.encode64(page.body)
          puts "200: indexed ##{indexed_pages += 1}"
          return if max && indexed_pages >= max.to_i
        else
          puts page.code.to_s + ': skipped'
        end
        puts
      end
    end
  end


end
