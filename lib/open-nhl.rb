require_relative 'fetcher'
require_relative 'parser'

module OpenNHL
  def self.info(options = {})
    file = OpenNHL::Fetcher::report(options)
    parser = OpenNHL::Parser.new(file)
    {
      game_info: parser.game_info,
      payload:   parser.payload,
    }
  end
end
