require 'pry'
require 'smarter_csv'
class CensusFor

 VERSION = "0.1.0"

  class CensusData
    def self.data
      @@data ||= load_data
    end

    def self.load_data
      SmarterCSV.process("data/2014-census-data.csv")
    end
  end

  class County
    def full_state_from_abbrev(state)
      "Alabama"
    end
    def population(county:, state:)

      result = CensusData.data.find {|x| x[:"geo.display_label"] == "#{county} County, #{state}"}
      if result
        result[:respop72014]
      else
        "not found"
      end
    end
  end

  class State
    def population(state_abbrev)
    end
  end
end
