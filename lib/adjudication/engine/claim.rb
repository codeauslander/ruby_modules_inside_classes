require "adjudication/engine/claim_line_item"

module Adjudication
  module Engine
    class Claim
      attr_accessor(
        :number,
        :provider,
        :subscriber,
        :patient,
        :start_date,
        :line_items
      )

      def initialize claim_hash
        @number = claim_hash['number']
        @provider = claim_hash['provider']
        @subscriber = claim_hash['subscriber']
        @patient = claim_hash['patient']
        @start_date = claim_hash['start_date']
        @line_items = claim_hash['line_items'].map{ |x| ClaimLineItem.new(x) }
      end

      def procedure_codes
        line_items.map(&:procedure_code)
      end

      def pay
        self.line_items.map!{|line_item|
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
        return self
      end
    end
  end
end
