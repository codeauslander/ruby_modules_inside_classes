module Adjudication
  module Engine
    class Adjudicator
      attr_reader :processed_claims

      def initialize
        @processed_claims = []
      end

      def unique(claim)
        @processed_claims.each do |processed_claim| 
          if  processed_claim.start_date == claim.start_date &&
              processed_claim.patient["ssn"] == claim.patient["ssn"] &&
              processed_claim.procedure_codes.sort == claim.procedure_codes.sort

              STDERR.puts "Rejected Claim, Claim already exist, Claim number -  #{claim.number}"

              return false
          end
        end
        return true
      end

      def pay(claim)
        claim.line_items.map!{|line_item|
          if line_item.preventive_and_diagnostic?
            line_item.pay! line_item.charged
          elsif line_item.ortho?
            line_item.pay! (line_item.charged * 0.25)
          else
            line_item.reject!
            STDERR.puts "Line item is nether preventive or diagnostic nir orthodontic, Procedure code - #{line_item.procedure_code}"
          end
          line_item
        }
        return claim
      end

      def adjudicate(claim)
        # TODO implement adjudication rules, and add any processed claims (regardless
        # of status) into the processed_claims attribute.

        @processed_claims << pay(claim) if unique(claim)
      end

    end
  end
end
