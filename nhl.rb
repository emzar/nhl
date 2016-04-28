require 'rubygems'
require 'nokogiri'
require 'open-uri'

events = []
(1..1230).each do |game_id|
  #url = "http://www.nhl.com/scores/htmlreports/20092010/PL020001.HTM"
  url = "http://www.nhl.com/scores/htmlreports/20152016/PL0#{20000 + game_id}.HTM"
  page = Nokogiri::HTML(open(url))

  parsed_events = page.css("tr[class='evenColor']").map do |event|
    props = event.css("td")
    time = props[3].text
    pos = time.index(':')
    prop_hash =
      {
        game_id: game_id,
        id:      props[0].text.to_i,
        period:  props[1].text.to_i,
        str:     props[2].text,
        time:    time[0..pos + 2],
        elapsed: time[pos + 3..-1],
        event:   props[4].text.downcase.to_sym,
        desc:    props[5].text,
      }
    if prop_hash[:event] != :gend
      players = props[6].css('font').map do |player|
        title = player['title'].split(" - ")
        {
          position: title[0].downcase.gsub(' ', '_').to_sym,
          name:     title[1],
          number:   player.text.to_i,
        }
      end
      prop_hash.merge!(players: players)
    end
    prop_hash
  end
  events.concat(parsed_events)
end

puts events.map { |event| "#{event[:game_id]} - #{event[:event].to_s.upcase}:\t#{event[:desc]}" }
