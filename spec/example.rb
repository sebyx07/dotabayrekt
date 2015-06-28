require 'dota_steam'
require 'benchmark'
### test DotaSteam::Parsers::MatchHistoryParser

parser = DotaSteam::Parsers::MatchHistoryParser.new

Benchmark.bm do |x|
  x.report('Match history Parse') { parser.parse_full_history }
end