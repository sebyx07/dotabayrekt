require 'dota_steam'

### test DotaSteam::Parsers::MatchHistoryParser

parser = DotaSteam::Parsers::MatchHistoryParser.new
parser.parse_full_history
match_ids = parser.result.map{|match| match.match_id}

puts "Number of matches: #{parser.result.size}"
puts "Unique matches: #{match_ids.uniq.size}"

dups = match_ids.group_by {|e| e}.map { |e| e[0] if e[1][1]}.compact

parser.result.each do |m|
  if dups.include? m.match_id
    puts m
  end
end