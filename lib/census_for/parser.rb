class CensusFor::Parser

  def get_csv_data
    result = CSV.read("data/2014-census-data.csv")
    result
  end
end
