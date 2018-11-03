require "adjudication/engine/version"
require "adjudication/providers"
require "adjudication/engine/adjudicator"
require "adjudication/engine/claim"

module Adjudication
  module Engine
    def self.valid_NPI(npi)
      npi && npi.length == 10 && npi.scan(/\D/).empty? 
    end

    def self.claim_match_provider(claim, providers)
      claim["npi"]
    end

    def self.run claims_data
      fetcher = Adjudication::Providers::Fetcher.new
      provider_data = fetcher.provider_data

      # TODO filter resulting provider data, match it up to claims data by
      # provider NPI (national provider ID), and run the adjudicator.
      # This method should return the processed claims

      normalize_provider_data = provider_data.select {|provider| valid_NPI(provider[2]) ? provider :  (STDERR.puts "Log bad NPI's to STDERR #{provider[2]}") }
      

      # processed_claims = []
      # claims_data.each do |claim|
      #   if claim_match_provider(claim, normalize_provider_data)
      #     processed_claims << claim
      #   end
      # end
      p normalize_provider_data.length

    end
  end
end
