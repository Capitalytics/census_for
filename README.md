# CensusFor 
v. 1.1

*CensusFor* lets you quickly return **2014** US Census data for _States_ and _Counties_, including Puerto Rico municipios.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'census_for'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install census_for

## Usage

**For quick US _County_ population estimates:**

    $ CensusFor::County.population("AnyCounty, AnyState")

Example:

    CensusFor::County.population("Travis County, Texas")
    CensusFor::County.population("fulton ga"
    CensusFor::County.population("East Baton Rouge Parish, LA")
    CensusFor::County.population("ponce municipio, pr")

For the first above example, "Travis County, Texas", returns:

    $ =>  1151145

**County .population method uses the following to _parse_city_state_ submissions:**

    $ CensusFor::County.parse_county_state("AnyCounty, AnyState")

Example:

    CensusFor::County.parse_county_state("Baldwin, AL")
    CensusFor::County.parse_county_state("ponce pr")
    CensusFor::County.parse_county_state("lafourche, LA")
    CensusFor::County.parse_county_state("Juneau, AK")

For these examples, returns:

    $ =>  "Baldwin County, Alabama"
    $ =>  "Ponce Municipio, Puerto Rico"
    $ =>  "Lafourche Parish, LA"
    $ =>  "Juneau City and Borough, Alaska"

**For quick _State_ Census retrieval:**

    CensusFor::State.population("AnyState")

Example:

    CensusFor::County.population("GA")
    CensusFor::County.population("new york")

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/evo21/census_for.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
