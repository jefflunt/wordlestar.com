require 'json'
require 'uri'
require 'net/http'

words = IO.read('best_words.txt').lines.map(&:strip)
defs = words[900..].each.with_index do |w, i|
  uri_str = "https://dictionaryapi.com/api/v3/references/collegiate/json/#{w}?key=#{ENV['DICT_API_KEY']}"
  print "\r#{w}: #{i+1}/#{words.length}"
  uri = URI(uri_str)
  res = Net::HTTP.get_response(uri)
  if res.is_a?(Net::HTTPSuccess)
    File.open("defs/#{w}.json", 'w'){|f| f.puts JSON.pretty_generate(JSON.parse(res.body)) }
  else
    {}
  end
end
