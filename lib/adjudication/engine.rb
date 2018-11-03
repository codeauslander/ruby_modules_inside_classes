require "adjudication/engine/version"
require "adjudication/providers"
require "adjudication/engine/adjudicator"
require "adjudication/engine/claim"

module Adjudication
  module Engine

    def self.valid_NPI(npi)
      return true if npi && npi.length == 10 && npi.scan(/\D/).empty?

      STDERR.puts "Provider's NPI is invalid #{npi || 'nil'}"
      return false
    end

    def self.match_provider(claim, providers)

      providers.each do |provider| 
        if claim["npi"] == provider[2]
          claim["provider"] = provider.to_h
          return claim 
        end
      end

      STDERR.puts "Claim does not match a Provider's NPI, Claim number - #{claim["number"]}"
      return false
    end



    def self.run claims_data
      fetcher = Adjudication::Providers::Fetcher.new
      provider_data = fetcher.provider_data

      # TODO filter resulting provider data, match it up to claims data by
      # provider NPI (national provider ID), and run the adjudicator.
      # This method should return the processed claims

      providers = provider_data.select { |provider| valid_NPI(provider[2]) }
      
      claims = claims_data.map {
        |claim| Claim.new(match_provider(claim, providers)) if match_provider(claim, providers)
      }.compact

      adjudicator = Adjudicator.new
      claims.each { |claim| adjudicator.adjudicate(claim) }

      puts
      puts
      puts
      puts "Processed Claims"
      adjudicator.processed_claims
    end
  end
end
