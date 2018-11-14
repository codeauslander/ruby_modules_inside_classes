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
    
  end

end
