class CreateCrawledPages < ActiveRecord::Migration
  def change

    create_table :crawled_pages do |t|
      t.string  :url,  :limit => 4_000
      t.text    :page, :limit => 16_777_215
    end

    add_index :crawled_pages, :url

  end
end
