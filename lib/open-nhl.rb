require_relative 'parser.rb'

module OpenNHL
  def self.events(options)
    OpenNHL::Parser.play_by_play(options)
  end

  def self.years
    OpenNHL::Parser::SEASON_GAMES.keys
  end

  def self.games_count(year)
    OpenNHL::Parser::SEASON_GAMES[year]
  end
end
