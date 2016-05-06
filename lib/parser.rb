require_relative 'game_info'
require_relative 'play_by_play'

module OpenNHL
  class Parser
    attr_reader :game_info, :payload

    def initialize(file)
      page = Nokogiri::HTML(file)
      @game_info = GameInfo::parse(page)
      @payload = PlayByPlay::parse(page)
    end
  end
end
