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
        expect(CensusFor::County.population("Travis, Texas")).to eq 1151145
      end
      it "calculates correctly given counties/states with > 1 name" do
        expect(CensusFor::County.population("Blue Earth, MN")).to eq 200111
        expect(CensusFor::County.population("Kent, Rhode Island")).to eq 200111
        expect(CensusFor::County.population("Blue Earth, MN")).to eq 200111
        expect(CensusFor::County.population("East Baton Rouge Parish, LA")).to eq 1151145
        expect(CensusFor::County.population("New York County, New York")).to eq 200111
      end
      it "calculates correctly given parish, for Louisiana" do
        expect(CensusFor::County.population("tangipahoa Parish, Louisiana")).to eq 127049
      end
      it "calculates correctly given county, state abbreviation" do
        expect(CensusFor::County.population("Baldwin, al")).to eq 200111
        expect(CensusFor::County.population("Tangipahoa, LA")).to eq 127049
      end
      it "calculates correctly when 'county'/'parish' included in county name" do
        expect(CensusFor::County.population("baldwin county AL")).to eq 200111
        expect(CensusFor::County.population("Clarke County, georgia")).to eq 120938
        expect(CensusFor::County.population("Tangipahoa Parish, LA")).to eq 127049
      end
      it "calculates correctly with capitals in county name, eg. DeKalb" do
        expect(CensusFor::County.population("DeKalb, GA")).to eq 722161
      end
      it "returns 'Not Found' with non-county request" do
        expect(CensusFor::County.population("Awesome County, TX")).to eq "not found"
      end

      pending "need dataset and code additions for municipalities in PR" do
        it "calculates correctly, given municipalities in Puerto Rico" do
          expect(CensusFor::County.population("Ponce, PR")).to eq 166327
          expect(CensusFor::County.population("Ponce Municipio, PR")).to eq 166327
          expect(CensusFor::County.population("ponce municipality, puerto rico")).to eq 166327
        end
      end
    end
  end

  describe CensusFor::State do
    describe "population" do
      it "calculates correctly, given full state name" do
        expect(CensusFor::State.population("Wyoming")).to eq 584153
        expect(CensusFor::State.population("North Dakota")).to eq 739482
      end
      it "calculates correctly, given 'Puerto Rico'" do
        expect(CensusFor::State.population("Puerto Rico")).to eq 3548397
        # I added data row to dataset from US PR census 2014
      end
      it "calculates correctly, given variations on request string entry" do
        expect(CensusFor::State.population("north dakota")).to eq 739482
        expect(CensusFor::State.population("puerto Rico")).to eq 3548397
        expect(CensusFor::State.population("NORTH DAKOTA")).to eq 739482
      end
    end
  end
end

