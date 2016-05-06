require 'open-uri'
require_relative 'season'

module OpenNHL
  module Fetcher
    MAGIC_NHL_ID = 20000
    NHL_URL_PREFIX = "http://www.nhl.com/scores/htmlreports/"

    def self.report(options)
      season_info = OpenNHL::SEASONS.find { |season| season[:id] == options[:season_id] }
      game_id = options[:game_id]
      years = "#{season_info[:start_year]}#{season_info[:end_year]}"
      filename = "PL0#{MAGIC_NHL_ID + game_id}.HTM"
      url = NHL_URL_PREFIX + "#{years}/#{filename}"
      open(url)
    end
  end
end
