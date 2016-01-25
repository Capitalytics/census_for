require 'smarter_csv'

class CensusFor

  VERSION = "1.1"

  STATES =
    {
     ak: "alaska", al: "alabama", ar: "arkansas", az: "arizona",
     as: "american samoa",
     ca: "california", co: "colorado", ct: "connecticut",
     dc: "district of columbia",
     de: "delaware",
     fl: "florida",
     ga: "georgia",
     gu: "guam",
     hi: "hawaii",
     ia: "iowa", id: "idaho", il: "illinois", in: "indiana",
     ks: "kansas", ky: "kentucky",
     la: "louisiana",
     ma: "massachusetts", md: "maryland", me: "maine", mi: "michigan", mn: "minnesota", mo: "missouri", ms: "mississippi", mt: "montana",
     mh: "marshall islands",
     mp: "mariana islands",
     nc: "north carolina", nd: "north dakota", ne: "nebraska", nh: "new hampshire", nj: "new jersey", nm: "new mexico", nv: "nevada", ny: "new york",
     oh: "ohio", ok: "oklahoma", or: "oregon",
     pa: "pennsylvania",
     pr: "puerto rico",
     pw: "palau",
     ri: "rhode island",
     sc: "south carolina", sd: "south dakota", tn: "tennessee", tx: "texas",
     um: "u.s. minor outlying islands",
     ut: "utah",
     va: "virginia", vt: "vermont",
     vi: "virgin islands",
     wa: "washington", wi: "wisconsin", wv: "west virginia", wy: "wyoming",
     ae: "ae",
     aa: "ae",
     ap: "ae"
    }

  SWAPOUTS = {
    "saint" => "st.",
    "st" => "st."
  }

  class CensusData
    def self.data
      @@data ||= load_data
    end

    def self.load_data
      SmarterCSV.process(File.dirname(__FILE__)+"/../data/2014-census-data.csv")
    end
  end

  class County

    def self.population(request)
      self.new(request).population
    end

    def self.parse_county_state(request)
      self.new(request).parse_county_state
    end

    def initialize(request)
      @request = request
      @request_array = request_to_array_minus_countystring
      match_state_and_county
    end


    def match_state_and_county
      if @state = Abbrev.converter(@request_array.last)
        @county = @request_array[0...-1].join(' ')
      elsif @state = Abbrev.converter(@request_array.last(2).join(' '))
        @county = @request_array[0...-2].join(' ')
      elsif @state = Abbrev.converter(@request_array.last(3).join(' '))
        @county = @request_array[0...-3].join(' ')
      end
      @county = titleize(@county)
    end

    def population
      parsed_request = parse_county_state
      return County.population_lookup(parsed_request)
    end

    def parse_county_state
      result = CensusData.data.find do |x|
        x[:"geo.display_label"] == "#{@county} County, #{@state}" ||
        x[:"geo.display_label"] == "#{@county} Parish, #{@state}" ||
        x[:"geo.display_label"] == "#{@county} Municipio, #{@state}" ||
        x[:"geo.display_label"] == "#{@county} Municipality, #{@state}" ||
        x[:"geo.display_label"] == "#{@county} Borough, #{@state}" ||
        x[:"geo.display_label"] == "#{@county} Census Area, #{@state}" ||
        x[:"geo.display_label"] == "#{@county} City County, #{@state}" ||
        x[:"geo.display_label"] == "#{@county} City and Borough, #{@state}"
      end
      if result
        return result[:"geo.display_label"]
      end
      return "not found"
    end

    def titleize(string)
      string.to_s.split.map(&:capitalize).join(' ')
    end

    def request_to_array_minus_countystring
      initial_array = @request.to_s.downcase.split(/[\s,]+/)
      initial_array[0] = SWAPOUTS[initial_array[0]] if SWAPOUTS[initial_array[0]]
      initial_array - ["county"] - ["parish"] - ["borough"] - ["municipio"] - ["municipality"] - ["census"] - ["area"] - ["city"] - ["and"]
    end

    def self.population_lookup(parsed_county_state)
      if parsed_county_state == "not found"
        return "not found"
      else
        return CensusData.data.find { |x| x[:"geo.display_label"] == parsed_county_state }[:respop72014]
      end
    end
  end

  class State
    def self.population(request)
      state = Abbrev.converter(request)
      return population_lookup(state)
    end

    def self.population_lookup(state)
      if state
        counties_in_state = []

        CensusData.data.each do |x|
          counties_in_state << x if x[:"geo.display_label"].split(/\s*,\s*/).last == "#{state}"
        end

        counties_pop_total = 0
        counties_in_state.each do |c|
          counties_pop_total += c[:respop72014]
        end
        return counties_pop_total
      else
        return 'not found'
      end
    end
  end

  class Abbrev
    def self.converter(abbrev)
      if STATES.has_value?(abbrev.to_s.downcase)
        return abbrev.split.map(&:capitalize).join(' ')
      elsif STATES.has_key?(abbrev.to_s.downcase.to_sym)
        return STATES[abbrev.downcase.to_sym].split.map(&:capitalize).join(' ')
      else return nil
      end
    end
  end
end
