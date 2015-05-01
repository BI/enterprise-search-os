require 'csv'

module AnotherIndex
  # used to export the results
  class CsvStreamer

    def initialize(search_class, params)
      @search_class  = search_class
      @params        = params
      @export_fields = Settings.export_fields
    end

    def each
      yield @export_fields.to_csv
      # the :size is multiplied by the number of shards (which are 5) so the actual batch is 20 text documents
      # keeping it low avoids memory problems, in exchange to a bit less of speed
      @search_class.search_in_batches(@params, :params=>{:size=>4}) do |result|
        result.collection.each do |doc|
          source = doc.source
          yield build_csv(source)
        end
      end
    end

  private

    def build_csv(source)
      @export_fields.map do |k|
        source[k]
      end.to_csv
    end

  end
end
