class CensusFor
  module ImportData
    def get_csv_data
      binding.pry
      result = SmarterCSV.process("data/2014-census-data.csv")
      result
    end
  end

  class County
    include ImportData
    def population(county_and_state_abbrev)
      get_csv_data
    end
  end

  class State
    include ImportData
    def population(state_abbrev)
      get_csv_data
    end
  end
end
