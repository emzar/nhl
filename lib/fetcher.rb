require 'open-uri'

module OpenNHL
  module Fetcher
    MAGIC_NHL_ID = 20000
    NHL_URL_PREFIX = "http://www.nhl.com/scores/htmlreports/"

    def self.play_by_play(options)
      year = options[:year]
      game_id = options[:game_id]
      url = NHL_URL_PREFIX + "#{year}#{year + 1}/PL0#{MAGIC_NHL_ID + game_id}.HTM"
      open(url)
    end
  end
end
