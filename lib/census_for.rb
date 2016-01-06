class CensusFor

  VERSION = "0.1.0"

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
     nc: "north carolina", nd: "north dakota", ne: "nebraska", nh: "new hampshire", nj: "new jersey", nm: "new mexico", nv: "nevada", ny: "new york",
     oh: "ohio", ok: "oklahoma", or: "oregon",
     pa: "pennsylvania",
     pr: "puerto rico",
     ri: "rhode island",
     sc: "south carolina", sd: "south dakota", tn: "tennessee", tx: "texas",
     ut: "utah",
     va: "virginia", vt: "vermont",
     vi: "virgin islands",
     wa: "washingington", wi: "wisconsin", wv: "west virginia", wy: "wyoming"
    }

  class CensusData
    def self.data
      @@data ||= load_data
    end

    def self.load_data
      SmarterCSV.process("data/2014-census-data.csv")
    end
  end

  class County
    def self.population(request)
      parsed_request = parse_county_state(request)
      return population_lookup(parsed_request)
    end

    def self.parse_county_state(county_state)
      transit = county_state.downcase.split(/[\s,]+/) - ["county"] - ["parish"] - ["borough"] - ["municipio"] - ["municipality"]
      if transit.size >= 3
        result = []
        1.upto(transit.size) do |x|
          y = transit.size
          first = transit.take(x).join(' ')
          second = transit.last(y-x).join(' ')
          result << [first, second].flatten
        end
        return result
      else
        return [transit]
      end
    end

    def self.population_lookup(county_state)
      county_state.each do |cs|
        county_name = cs.first
        state_name = cs.last
        state = Abbrev.converter(state_name)
        result = CensusData.data.find { |x| x[:"geo.display_label"] == 
            "#{county_name.split.map(&:capitalize).join(' ')} County, #{state}" || x[:"geo.display_label"] == "#{county_name.split.map(&:capitalize).join(' ')} Parish, Louisiana" || x[:"geo.display_label"] == "#{county_name.split.map(&:capitalize).join(' ')} Municipio, Puerto Rico" }
        if result
          return result[:respop72014]
        end
      end
      return "not found" #preceding each loop matched nothing from query 
    end

    def self.coeff(county_state)
      coefficient = (population(county_state) * 1000 / highest_county_pop).to_f
      coefficient < 1 ? 1 : coefficient
    end

    def self.highest_county_pop
      most_populous_county = CensusData.data.max_by { |x| x[:respop72014] }
      most_populous_county[:respop72014]
        #for 2014, this is Los Angeles County, CA: pop 10,116,705
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
      else 'not found'
      end
    end
  end

  class Abbrev
    def self.converter(abbrev)
      if STATES.has_value?(abbrev.downcase)
        return abbrev.split.map(&:capitalize).join(' ')
      elsif STATES.has_key?(abbrev.downcase.to_sym)
        return STATES[abbrev.downcase.to_sym].split.map(&:capitalize).join(' ')
      else return nil
      end
    end
  end
end
