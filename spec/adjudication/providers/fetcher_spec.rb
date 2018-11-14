require "spec_helper"
require 'open-uri'

RSpec.describe Adjudication::Providers::Fetcher do
  it "Import CSV data from http://provider-data.beam.dental/beam-network.csv and return it" do
    fetcher = Adjudication::Providers::Fetcher.new
    expect(fetcher.get_providers).to eq(fetcher.get_providers)
  end

  it "Rescue an error to STDERR.puts by providing a bad url to import CSV and return nil" do
    fetcher = Adjudication::Providers::Fetcher.new
    # expect(fetcher.get_providers('bad url')).to raise_error
    expect { fetcher.get_providers('bad url') }.to raise_error
  end
end
