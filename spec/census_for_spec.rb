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
      it "calculates correctly given county, full state name" do
        expect(CensusFor::County.population("Baldwin, Alabama")).to eq 200111
        #expect(CensusFor::County.population("Kent, Rhode Island")).to eq 200111
        expect(CensusFor::County.population("Travis, Texas")).to eq 1151145
      end
      it "calculates correctly given parish, for Louisiana" do
        expect(CensusFor::County.population("tangipahoa Parish, Louisiana")).to eq 127049
      end
      it "calculates correctly given county, state abbreviation" do
        expect(CensusFor::County.population("Baldwin, al")).to eq 200111
        expect(CensusFor::County.population("Tangipahoa, LA")).to eq 127049
      end
      it "calculates correctly when 'county' included in county name" do
        expect(CensusFor::County.population("baldwin county AL")).to eq 200111
        expect(CensusFor::County.population("Clarke County, georgia")).to eq 120938
        expect(CensusFor::County.population("Tangipahoa Parish, LA")).to eq 127049
      end
    end
  end

  describe CensusFor::County do
    describe "population" do
      it "calculates correctly, given full state name" do
        expect(CensusFor::State.population("Wyoming")).to eq 584153
        expect(CensusFor::State.population("North Dakota")).to eq 739482
      end
#        expect(CensusFor::County.population("Travis, Texas")).to eq 1151145
#      end
#      it "calculates correctly given parish, for Louisiana" do
#        expect(CensusFor::County.population("tangipahoa Parish, Louisiana")).to eq 127049
#      end
#      it "calculates correctly given county, state abbreviation" do
#        expect(CensusFor::County.population("Baldwin, al")).to eq 200111
#        expect(CensusFor::County.population("Tangipahoa, LA")).to eq 127049
#      end
#      it "calculates correctly when 'county' included in county name" do
#        expect(CensusFor::County.population("baldwin county AL")).to eq 200111
#        expect(CensusFor::County.population("Clarke County, georgia")).to eq 120938
#        expect(CensusFor::County.population("Tangipahoa Parish, LA")).to eq 127049
#      end
    end
  end
end

