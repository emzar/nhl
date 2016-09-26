# OpenNHL
A simple gem to parse NHL HTML reports.

## Usage
- `OpenNHL::info(options)` returns a Hash of common info and all events count of the game specified by season id and geme id
```ruby
OpenNHL::info(season_id: 93, game_id: 100)
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
