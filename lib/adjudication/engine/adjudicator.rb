module Adjudication
  module Engine
    class Adjudicator
      attr_reader :processed_claims

      def initialize
        @processed_claims = []
      end

      def duplicated_claim(claim, processed_claims)
        processed_claims.each do |processed_claim| 
          if  processed_claim.start_date == claim.start_date &&
              processed_claim.patient["ssn"] == claim.patient["ssn"] 
          # processed_claim.patient["ssn"] == claim.patient["ssn"] &&
              p processed_claim.line_items
              return true
          end

        end
        return false
      end


      def adjudicate(claim)
        # TODO implement adjudication rules, and add any processed claims (regardless
        # of status) into the processed_claims attribute.

        # 1. As you can see in the claims JSON fixture, a claim is an instance of a visit to the dentist. It has line items, which are individual services billed by the dentist. Each line item or service is adjudicated by itself, and can be rejected or paid by itself.
        # 2. Reject any duplicate claims. A duplicate claim is defined as having the same start date, patient SSN, and set of procedures codes as another claim. All but the first claim in a duplicate set should be rejected.
        # 3. If the provider was not successfully matched, reject the claim and all of its line items. This plan does not cover out of network at all. :(
        # 4. Fully pay any preventive and diagnostic codes. Luckily, your coworker already provided a helper method on the `ClaimLineItem` model to help you figure this out.
        # 5. Pay any orthodontic line item at 25% of the charged rate. Again, your coworker added a helper method on `ClaimLineItem` to help you with this.
        # 6. Reject anything else.
        # 7. Log any rejections to STDERR.

        # same start date, patient SSN, and set of procedures codes as another claim
        duplicated_claim(claim)

        

      end
    end
  end
end
