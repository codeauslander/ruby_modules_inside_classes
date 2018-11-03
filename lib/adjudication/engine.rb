require "adjudication/engine/version"
require "adjudication/providers"
require "adjudication/engine/adjudicator"
require "adjudication/engine/claim"

module Adjudication
  module Engine
    def self.valid_NPI(npi)
      npi && npi.scan(/\D/).empty? && npi.length == 10
    end

    def self.match_provider(claim, normalize_provider_data)
      normalize_provider_data.each do |provider| 
        if claim["npi"] == provider[2]
          claim["provider"] = provider.to_h
          return claim 
        end
      end
      return false
    end



    def self.run claims_data
      fetcher = Adjudication::Providers::Fetcher.new
      provider_data = fetcher.provider_data

      # TODO filter resulting provider data, match it up to claims data by
      # provider NPI (national provider ID), and run the adjudicator.
      # This method should return the processed claims

      normalize_provider_data = provider_data.select {
        |provider| valid_NPI(provider[2]) ? 
          provider :  
          (STDERR.puts "Log bad NPI's to STDERR #{provider[2]}")
      }
      
      processed_claims = claims_data.map {
        |claim| Claim.new(match_provider(claim, normalize_provider_data)) if match_provider(claim, normalize_provider_data)
      }.compact

      processed_claims
    end
  end
end
