require "adjudication/engine/version"
require "adjudication/providers"
require "adjudication/engine/adjudicator"
require "adjudication/engine/claim"

module Adjudication
  module Engine
    # VERSION = 1

    def self.valid_NPI(npi)
      return true if npi && npi.length == 10 && npi.scan(/\D/).empty?
      STDERR.puts "Provider's NPI is invalid #{npi || 'nil'}"
    end

    def self.match_provider(claim, providers)
      if provider = providers.find{ |provider| provider.npi == claim['npi'] }
        claim["provider"] = provider
        return Claim.new(claim)
      end
      STDERR.puts "Claim does not match a Provider's NPI, Claim number - #{claim["number"]}"
    end

    def self.message_duplicate_claim(claim)
      STDERR.puts "Rejected Claim, Claim already exist, Claim number -  #{claim.number}" 
    end

    def self.unique(claims)
      unique_claims = []
      claims.each do |claim| 
        add_claim = true
        unique_claims.each do |unique_claim|   
          if unique_claim.start_date == claim.start_date &&
             unique_claim.patient["ssn"] == claim.patient["ssn"] &&
             unique_claim.procedure_codes.sort == claim.procedure_codes.sort
            add_claim = false
            message_duplicate_claim(claim)
          end
        end
        unique_claims << claim if add_claim
      end
      return unique_claims
    end

    def self.run claims_data
      fetcher = Adjudication::Providers::Fetcher.new
      providers = fetcher.get_providers.map{|provider| Adjudication::Providers::Provider.new(provider)}

      # TODO filter resulting provider data, match it up to claims data by
      # provider NPI (national provider ID), and run the adjudicator.
      # This method should return the processed claims

      providers = providers.select { |provider| valid_NPI(provider.npi) }
      
      claims = claims_data.map {
        |claim_data|  match_provider(claim_data, providers)
      }.compact

      adjudicator = Adjudicator.new
      unique(claims).each { |claim| adjudicator.adjudicate(claim.pay)} 

      puts
      puts
      puts
      puts "Processed Claims"
      adjudicator.processed_claims
    end
    
  end
end
