require_relative 'parser.rb'

module OpenNHL
  def self.events(options)
    OpenNHL::Parser.play_by_play(options)
  end
end
