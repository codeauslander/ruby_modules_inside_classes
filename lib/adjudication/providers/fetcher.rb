module Adjudication
  module Providers
    require 'open-uri'
    require 'csv'
    
    class Fetcher
      def provider_data

        # TODO Import CSV data from http://provider-data.beam.dental/beam-network.csv
        # and return it.

        beam_network_csv = open('http://provider-data.beam.dental/beam-network.csv')
        csv_array_per_line = CSV.parse(beam_network_csv, :headers=>true)
        return csv_array_per_line
        
      end
    end
  end
end
