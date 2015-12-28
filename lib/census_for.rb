module CensusFor

  class County
    binding.pry
    def population(county_and_state_abbrev)
      get_csv_data
    end

  end

  class State
    def population(state_abbrev)
      get_csv_data
    end
  end

  require_relative "census_for/parser"
end
