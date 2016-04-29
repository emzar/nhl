require 'rubygems'
require 'nokogiri'
require 'open-uri'

module NHL
  class Parser

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

    def self.play_by_play(year, game_id)
      url = "http://www.nhl.com/scores/htmlreports/#{year}#{year + 1}/PL0#{20000 + game_id}.HTM"
      page = Nokogiri::HTML(open(url))
      page.css("tr[class='evenColor']").map do |event_html|
        props = event_html.css('td')
        time = props[3].text
        pos = time.index(':')
        event =
          {
            id:      props[0].text.to_i,
            period:  props[1].text.to_i,
            str:     props[2].text,
            time:    time[0..pos + 2],
            elapsed: time[pos + 3..-1],
            type:    props[4].text.downcase.to_sym,
            desc:    props[5].text,
          }
        players = parse_players(event_html)
        event.merge!(players) if players
        event
      end
    end

    private

    def self.parse_players(html)
      tables = html.css('table')
      return if tables.empty?
      visitor_players = parse_players_table(tables[0])
      home_players = parse_players_table(tables[visitor_players.size + 1])
      {
        players:
        {
          visitor: visitor_players,
          home:    home_players,
        }
      }
    end

    def self.parse_players_table(html)
      return unless html
      html.css('font').map do |player|
        title = player['title'].split(' - ')
        {
          position: title[0].downcase.gsub(' ', '_').to_sym,
          name:     title[1],
          number:   player.text.to_i,
        }
      end
    end
  end
end
