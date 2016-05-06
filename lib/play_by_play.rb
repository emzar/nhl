require 'nokogiri'

module OpenNHL
  module PlayByPlay
    EVENT_CSS_SELECTOR = "tr[class='evenColor']"

    def self.parse(page)
      page.css(EVENT_CSS_SELECTOR).map { |html| parse_event(html) }
    end

    private

    def self.parse_event(html)
      props = html.css('td')
      time = props[3].text
      pos = time.index(':')
      event =
        {
          event_id: props[0].text.to_i,
          period:   props[1].text.to_i,
          str:      props[2].text,
          time:     time[0..pos + 2],
          elapsed:  time[pos + 3..-1],
          type:     props[4].text.downcase.to_sym,
          desc:     props[5].text,
        }
      players = parse_players(html)
      event.merge!(players) if players
      event
    end

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
