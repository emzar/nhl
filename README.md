# OpenNHL
A simple gem to parse NHL HTML reports.

## Usage
- `OpenNHL::games_count(year)` returns a count of games in specified year
```ruby
OpenNHL::games_count(2012)
```

- `OpenNHL::years` returns an Array of all available years of seasons start
```ruby
OpenNHL::years
```

- `OpenNHL::events(options)` returns an Array of all events from the game specified by year and id
```ruby
OpenNHL::events(year: 2015, game_id: 1)
```

## Installation instructions
To install this gem, just call
```sh
gem install open-nhl
```
Add the following line at top of your ruby files to use open-nhl
```ruby
require 'open-nhl'
```
## License

The contents of this repository are covered under the [MIT License](LICENSE).
