require 'nokogiri'
require 'scanf'

module OpenNHL
  class Parser
    EVENT_CSS_SELECTOR = "tr[class='evenColor']"
    GAME_ID_FORMAT = "Game %d"
    ATTENDANCE_FORMAT = "Attendance %d,%d"

    TEAM_PROPERTIES =
      {
        visitor:
          {
            score_index: 3,
            game_type:   :away,
          },
        home:
          {
            score_index: 16,
            game_type:   :home,
          },
      }

    def initialize(file)
      @page = Nokogiri::HTML(file)
    end

    def play_by_play
      @page.css(EVENT_CSS_SELECTOR).map { |html| parse_event(html) }
    end

    def game_info
      props = @page.css("td[align='center']")
      info = { game_id: props[12].text.scanf(GAME_ID_FORMAT).first }
      info.merge!(Parser::parse_arena_info(props))
      info.merge!(Parser::parse_game_time(props))
      TEAM_PROPERTIES.each do |key, value|
        info.merge!(key => Parser::parse_team_properties(props, value))
      end
      info
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

    def self.parse_game_time(props)
      date = props[9].text
      time = props[11].text.split(';')
      {
        start: DateTime.parse(date + time[0]),
        end:   DateTime.parse(date + time[1]),
      }
    end

    def self.parse_arena_info(props)
      arena_info = props[10].text
      attendance = arena_info.scanf(ATTENDANCE_FORMAT)
      attendance = attendance[0] * 1000 + attendance[1]
      pos = arena_info.index('at')
      {
        attendance: attendance,
        arena:      arena_info[pos + 'at'.length + 1..-1],
      }
    end

    def self.parse_team_properties(props, value)
      index = value[:score_index]
      team_property = props[index + 2].text
      pos = team_property.index('Game')
      game_type = value[:game_type]
      games = team_property[pos..-1].scanf("Game %d #{game_type.to_s.capitalize} Game %d")
      {
        title:       team_property[0..pos - 1],
        game:        games[0],
        game_type => games[1],
        score:       props[index].text.to_i
      }
    end
  end
end
