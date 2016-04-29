require 'nokogiri'
require 'open-uri'

module OpenNHL
  module Fetcher
    MAGIC_NHL_ID = 20000

    def self.play_by_play(options)
      year = options[:year]
      game_id = options[:game_id]
      url = "http://www.nhl.com/scores/htmlreports/#{year}#{year + 1}/PL0#{MAGIC_NHL_ID + game_id}.HTM"
      Nokogiri::HTML(open(url))
    end
  end
end
