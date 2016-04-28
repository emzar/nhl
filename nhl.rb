require 'rubygems'
require 'nokogiri'
require 'open-uri'

url = "http://www.nhl.com/scores/htmlreports/20092010/PL020001.HTM"
page = Nokogiri::HTML(open(url))


game_info = page.css("table[id='GameInfo']").first
puts game_info.css("td").map(&:text)

exit

events = page.css("tr[class='evenColor']").map do |event|
  props = event.css("td")
  time = props[3].text
  pos = time.index(':')
  prop_hash =
    {
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

puts events.select { |event| event[:event] == :goal}
