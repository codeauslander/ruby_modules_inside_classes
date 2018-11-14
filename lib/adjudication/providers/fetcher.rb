module Adjudication
  module Providers
    require 'open-uri'
    require 'csv'

    class Fetcher
      def get_providers(url = 'http://provider-data.beam.dental/beam-network.csv')
        # TODO Import CSV data from http://provider-data.beam.dental/beam-network.csv
        # and return it.
        begin
          beam_network_csv = open(url)
          providers = CSV.parse(beam_network_csv, :headers=>true)
          return providers
        rescue OpenURI::HTTPError => error
          response = error.io
          STDERR.puts response.status 
          STDERR.puts response.string
        end  
      end
    end
  end
end
