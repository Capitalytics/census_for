require 'pry'
require 'smarter_csv'
require 'spec_helper'

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
    describe "#population" do
      it "calculates correctly given county, full state name" do
        expect(CensusFor::County.population("Baldwin, Alabama")).to eq 200111
        expect(CensusFor::County.population("Travis, Texas")).to eq 1151145
        expect(CensusFor::County.population("King, Washington")).to eq 2079967
      end
      it "calculates correctly given counties/states with > 1 name" do
        expect(CensusFor::County.population("Blue Earth, MN")).to eq 65385
        expect(CensusFor::County.population("Kent, Rhode Island")).to eq 165128
        expect(CensusFor::County.population("Blue Uuuurrth, MN")).to eq "not found"
        expect(CensusFor::County.population("East Baton Rouge Parish, LA")).to eq 446042
        expect(CensusFor::County.population("New York County, New York")).to eq 1636268
        expect(CensusFor::County.population("new York new york")).to eq 1636268
      end
      it "calculates correctly given parish, for Louisiana" do
        expect(CensusFor::County.population("tangipahoa Parish, Louisiana")).to eq 127049
      end
      it "calculates correctly given county, state abbreviation" do
        expect(CensusFor::County.population("Baldwin, al")).to eq 200111
        expect(CensusFor::County.population("Tangipahoa, LA")).to eq 127049
        expect(CensusFor::County.population("king wa")).to eq 2079967

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
      it "calculates correctly, given municipalities in Puerto Rico" do
        expect(CensusFor::County.population("Ponce, PR")).to eq 153540
        expect(CensusFor::County.population("Ponce Municipio, PR")).to eq 153540
        expect(CensusFor::County.population("ponce municipality, puerto rico")).to eq 153540
        expect(CensusFor::County.population("San Sebastian Municipio, PR")).to eq 39969
      end
      it "calculates correctly, given 'District of Columbia'" do
        expect(CensusFor::County.population("District of Columbia, District of Columbia")).to eq 658893
        expect(CensusFor::County.population("District of Columbia, DC")).to eq 658893
      end
    end

    describe "#parse_county_state" do
      it "parses submitted county and state format(s) to return string key data matching US-Census datafile" do
        expect(CensusFor::County.parse_county_state("Baldwin, Alabama")).to eq "Baldwin County, Alabama"
        expect(CensusFor::County.parse_county_state("east baton rouge, la")).to eq "East Baton Rouge Parish, Louisiana"
        expect(CensusFor::County.parse_county_state("Ponce, PR")).to eq "Ponce Municipio, Puerto Rico"
        expect(CensusFor::County.parse_county_state("Blue Uuuurth MN")).to eq "not found"
        expect(CensusFor::County.parse_county_state("new york, ny")).to eq "New York County, New York"
      end
    end

    describe "#coeff" do
      binding.pry
      #least populous US county has coefficient of 1.0; most populous county has 100.0
      it "calculates population coefficient, given county name" do
        expect(CensusFor::County.coeff("Los Angeles County, CA")).to eq 1000
        expect(CensusFor::County.coeff("Loving County, TX")).to eq 1
        expect(CensusFor::County.coeff("East Baton Rouge Parish, Louisiana")).to eq 44
        expect(CensusFor::County.coeff("Fulton, Georgia")).to eq 98
        expect(CensusFor::County.coeff("Clarke, GA")).to eq 11
      end
    end
  end

  describe CensusFor::State do
    describe "#population" do
      it "calculates correctly, given full state name" do
        expect(CensusFor::State.population("Wyoming")).to eq 584153
        expect(CensusFor::State.population("North Dakota")).to eq 739482
        expect(CensusFor::State.population("Awesome")).to eq 'not found'
      end
      it "calculates correctly, given state abbrev" do
        expect(CensusFor::State.population("WY")).to eq 584153
        expect(CensusFor::State.population("nd")).to eq 739482
        expect(CensusFor::State.population("PR")).to eq 3548397
        expect(CensusFor::State.population("nz")).to eq 'not found'
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
      it "calculates correctly, given special postal/county codes" do
        expect(CensusFor::State.population("AS")).to eq 55165
        expect(CensusFor::State.population("DC")).to eq 658893
        expect(CensusFor::State.population("GU")).to eq 165124
        expect(CensusFor::State.population("MH")).to eq 52634
        expect(CensusFor::State.population("MP")).to eq 53855
        expect(CensusFor::State.population("pw")).to eq 20918
        expect(CensusFor::State.population("vi")).to eq 104737
        expect(CensusFor::State.population("ae")).to eq 1318428
        expect(CensusFor::State.population("aa")).to eq 1318428
        expect(CensusFor::State.population("ap")).to eq 1318428
        expect(CensusFor::State.population("um")).to eq 300
      end
      it "calculates correctly, given other US territories" do
        expect(CensusFor::State.population("AS")).to eq 55165
        
        expect(CensusFor::State.population("district of columbia")).to eq 658893
        expect(CensusFor::State.population("u.s. minor outlying islands")).to eq 300
        expect(CensusFor::State.population("mariana islands")).to eq 53855
        expect(CensusFor::State.population("Marshall islands")).to eq 52634

      end
    end
  end
end
