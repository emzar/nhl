require 'nokogiri'
require 'scanf'

module OpenNHL
  module GameInfo
    GAME_ID_FORMAT = "%s%d"
    ATTENDANCE_FORMAT = "%s%d,%d"
    TEAM_PROPERTIES =
      {
        visitor:
          {
            score_index:  3,
            game_type:    :away,
            game_type_fr: 'Étr.',
          },
        home:
          {
            score_index:  16,
            game_type:    :home,
            game_type_fr: 'Dom.',
          },
      }

    def self.parse(page)
      props = page.css("td[align='center']")
      info = { game_id: parse_game_id(props) }
      info.merge!(parse_arena_info(props))
      info.merge!(parse_game_time(props))
      TEAM_PROPERTIES.each do |key, value|
        info.merge!(key => parse_team_properties(props, value))
      end
      info
    end

    private

    def self.parse_game_id(props)
      props[12].text.scanf(GAME_ID_FORMAT)[1]
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
      attendance = attendance[1] * 1000 + attendance[2]
      at = 'at'
      pos = arena_info.index(at)
      if pos.nil?
        at = '@'
        pos = arena_info.index(at)
      end
      {
        attendance: attendance,
        arena:      arena_info[pos + at.length + 1..-1],
      }
    end

    def self.parse_team_properties(props, value)
      index = value[:score_index]
      team_property = props[index + 2].text
      game_type = value[:game_type].to_s.capitalize
      match_pos = team_property.index('Match')
      game_pos = team_property.index('Game')
      pos = match_pos ? match_pos : game_pos
      games_format =
        if match_pos
          game_type_fr = value[:game_type_fr]
          "Match/Game %d #{game_type_fr}/#{game_type} %d"
        else
          "Game %d #{game_type} Game %d"
        end
      games = team_property[pos..-1].scanf(games_format)
      {
        title:               team_property[0..pos - 1],
        game:                games[0],
        value[:game_type] => games[1],
        score:               props[index].text.to_i,
      }
    end
  end
end
