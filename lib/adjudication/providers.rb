require "adjudication/providers/fetcher"
# Last Name,First Name,NPI,Practice Name,Address Line 1,Address Line 2,City,State,Zip,Speciality
module Adjudication
  module Providers
    class Provider
      
      attr_accessor(
          :last_name,
          :first_name,
          :npi,
          :practice_name,
          :address_line_1,
          :address_line_2,
          :city,
          :state,
          :zip,
          :specialty,
          :claims
      )

      def initialize(provider)
        @last_name = provider['Last Name']
        @first_name = provider['First Name']
        @npi = provider['NPI']
        @practice_name = provider['Practice Name']
        @address_line_1 = provider['Address Line 1']
        @address_line_2 = provider['Address Line 2']
        @city = provider['City']
        @state = provider['State']
        @zip = provider['Zip']
        @specialty = provider['Specialty']
      end

    end
  end
end
