class ExportResultsController < ApplicationController

  include ActionController::Live

  def csv
    response.headers['Content-Type']        = 'text/event-stream'
    response.headers['Content-disposition'] = 'attachment; filename=exported-results.csv'

    streamer = "#{params[:searched_index].capitalize}::CsvStreamer".constantize
    streamer.new(search_class, params).each do |csv_line|
      response.stream.write csv_line
    end

  ensure
    response.stream.close
  end

end
