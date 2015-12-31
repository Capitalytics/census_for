require 'pry'
require 'smarter_csv'
class CensusFor

  VERSION = "0.1.0"

  STATES =
    {
     "AK": "Alaska", "AL": "Alabama", AR: "Arkansas", AZ: "Arizona",
     AS: "American Samoa",
     CA: "California", CO: "Colorado", CT: "Connecticut",
     DC: "District of Columbia",
     DE: "Delaware",
     FL: "Florida",
     GA: "Georgia",
     GU: "Guam",
     HI: "Hawaii",
     IA: "Iowa", ID: "Idaho", IL: "Illinois", IN: "Indiana",
     KS: "Kansas", KY: "Kentucky",
     LA: "Louisiana",
     MA: "Massachusetts", MD: "Maryland", ME: "Maine", MI: "Michigan", MN: "Minnesota", MO: "Missouri", MS: "Mississippi", MT: "Montana",
     NC: "North Carolina", ND: "North Dakota", NE: "Nebraska", NH: "New Hampshire", NJ: "New Jersey", NM: "New Mexico", NV: "Nevada", NY: "New York",
     OH: "Ohio", OK: "Oklahoma", OR: "Oregon",
     PA: "Pennsylvania",
     PR: "Puerto Rico",
     RI: "Rhode Island",
     SC: "South Carolina", SD: "South Dakota", TN: "Tennessee", TX: "Texas",
     UT: "Utah",
     VA: "Virginia", VT: "Vermont",
     VI: "Virgin Islands",
     WA: "Washington", WI: "Wisconsin", WV: "West Virginia", WY: "Wyoming"
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
      county_state.downcase.split(/[\s,]+/) - ["county"] - ["parish"]
    end

    def self.population_lookup(county_state)
      county_name = county_state.first
      state_name = county_state.last
      state = Abbrev.converter(state_name)
      result = CensusData.data.find { |x| x[:"geo.display_label"] == 
          "#{county_name.capitalize} County, #{state.capitalize}" || x[:"geo.display_label"] == "#{county_name.capitalize} Parish, Louisiana" }

      if result
        result[:respop72014]
      else
        "not found"
      end
    end
  end

  class State
    def self.population(request)
      state = Abbrev.converter(request)
      return population_lookup(state)
    end

    def self.population_lookup(state)
      counties_in_state = []

      CensusData.data.each do |x|
        counties_in_state << x if x[:"geo.display_label"].split(/\s*,\s*/).last == "#{state}"
      end

      counties_pop_total = 0

      counties_in_state.each do |c|
        counties_pop_total += c[:respop72014]
      end
      counties_pop_total
    end
  end
  class Abbrev
    def self.converter(abbrev)
      if STATES.has_value?(abbrev.split.map(&:capitalize).join(' '))
        return abbrev.split.map(&:capitalize).join(' ')
      elsif STATES.has_key?(abbrev.upcase.to_sym)
        return STATES[abbrev.upcase.to_sym]
      else return "not found"
      end
    end
  end
end
