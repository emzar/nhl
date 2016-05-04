require_relative 'fetcher'
require_relative 'parser'

module OpenNHL
  SEASON_GAMES =
    {
      2009 => 1230,
      2010 => 1230,
      2011 => 1230,
      2012 => 720,
      2013 => 1230,
      2014 => 1230,
      2015 => 1230,
    }

  def self.events(options)
    file = OpenNHL::Fetcher::play_by_play(options)
    OpenNHL::Parser::play_by_play(file)
  end

  def self.years
    OpenNHL::SEASON_GAMES.keys
  end

  def self.games_count(year)
    OpenNHL::SEASON_GAMES[year]
  end
end
