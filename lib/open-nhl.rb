require_relative 'fetcher'
require_relative 'parser'

module OpenNHL
  def self.events(options)
    file = OpenNHL::Fetcher::play_by_play(options)
    OpenNHL::Parser.new(file).play_by_play
  end

  def self.game_info(options)
    file = OpenNHL::Fetcher::play_by_play(options)
    OpenNHL::Parser.new(file).game_info
  end
end
