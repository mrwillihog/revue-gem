require 'trollop'
require 'rest-client'
require 'json'

PROTOCOL = "https"
URL = "#{PROTOCOL}://revue.io"
PATH = "/api/v1"

opts = Trollop::options do
  version "revue 1.0.1 (c) 2013 Matthew Williams"
  banner <<-EOS
revue is a tool for creating code reviews from a diff file.

Usage:

revue <diff_file>

where [options] are:
EOS

  opt :url, "Use an alternative revue instance, e.g. a local installation", :short => "-u", :default => URL
  opt :verbose, "Make the program more talkative", :short => "-v"
  opt :version, "Print version and exit", :short => "-V"
end

RestClient.proxy = ENV["#{PROTOCOL}_proxy"] if ENV["#{PROTOCOL}_proxy"]
RestClient.log = STDOUT if opts[:verbose]
begin
  response = RestClient.post "#{opts[:url]}/#{PATH}", { 'content' => ARGF.read }.to_json, :content_type => :json, :accept => :json
  puts JSON.parse(response)['url']
rescue => e
  STDERR.puts JSON.parse(e.response)["errors"]
  exit 1
end
