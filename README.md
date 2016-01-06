# CensusFor 
v. 1.0

*CensusFor* lets you quickly return **2014** US Census data for _States_ and _Counties_, including Puerto Rico municipios.

Additional feature is a _Scaled Ranking_ of US counties by population, with the vast majority of scaled coeffeicient 'rankings' falling between 1 and 99. (Scale is from 1: _least populous_ to 1000: _most populous_).

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

**For quick _State_ Census retrieval:**

    CensusFor::State.population("AnyState")

Example:

    CensusFor::County.population("GA")
    CensusFor::County.population("new york")
    
**For quick _Coeff_ (county rankings by population) retrieval:**

    CensusFor::State.coeff("AnyCounty, AnyState")

Example:

    CensusFor::County.coeff("Clarke County, Georgia")
    CensusFor::County.coeff("clarke ga")
    
I included this coefficient calculator to rank each US county by population, on a linear scale, from least populous counties (coeff of 1), to the most populous (coeff of 1000).  The vast majority of results will fall in a range from 1-99.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/evo21/census_for.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
