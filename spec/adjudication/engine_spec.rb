require "spec_helper"
require 'json'

RSpec.describe Adjudication::Engine do
  it "has a version number" do
    expect(Adjudication::Engine::VERSION).not_to be nil
  end

  it "does something useful" do
    claims_data = 'spec/fixtures/claims.json'
    claims = JSON.parse(File.open(claims_data).read)
    processed_claims = Adjudication::Engine.run(claims)
    expect(processed_claims.length).to be 3
  end

  it "unique claims are returned" do
    test_claim_numbers = ['2017-09-01-123214','2017-09-06-983745','2017-09-10-112494']

    claims_data = 'spec/fixtures/claims.json'
    claims = JSON.parse(File.open(claims_data).read)
    processed_claims = Adjudication::Engine.run(claims)

    processed_claims_numbers = processed_claims.map{ |processed_claim| processed_claim.number}

    expect(test_claim_numbers).to match_array(processed_claims_numbers)
  end

end
