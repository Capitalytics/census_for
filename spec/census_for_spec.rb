require 'spec_helper'
require 'pry'
require 'smarter_csv'

describe CensusFor do
  it 'has a version number' do
    expect(CensusFor::VERSION).not_to be nil
  end
end

describe CensusFor::CensusData do
  it "parses the census csv file into @@data" do
    expect(CensusFor::CensusData.data).to_not be_empty
  end
end

context "CensusFor" do
  describe CensusFor::County do
    describe "population" do
      it "calculates correctly given county, full state" do
        expect(CensusFor::County.new.population(county: "Baldwin", state: "Alabama")).to eq 200111
        expect(CensusFor::County.new.population(county: 'Clarke', state: "Georgia")).to eq 120938
      end
      it "calculates correctly given county, state abbreviation" do
        expect(CensusFor::County.new.population(county: "Baldwin", state: "AL")).to eq 200111
      end
    end
  end
end

