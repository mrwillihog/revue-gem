require 'trollop'
require 'rest-client'
require 'json'

PROTOCOL = "https"
URL = "#{PROTOCOL}://revue.io"
PATH = "api/v1"
LOG = nil

def log(str)
  if LOG
    LOG.puts str
  end
end

opts = Trollop::options do
  version "revue 1.0.2 (c) 2013 Matthew Williams"
  banner <<-EOS
revue is a tool for creating code reviews from a diff file.

Usage:

revue <diff_file>

where [options] are:
EOS
  opt :gsvn, "Generate an SVN diff revue for a given directory or the current directory if blank", :short => "-s"
  opt :ggit, "Generate a Git diff revue for a given directory or the current directory if blank", :short => "-g"
  opt :url, "Use an alternative revue instance, e.g. a local installation", :short => "-u", :default => URL
  opt :verbose, "Make the program more talkative", :short => "-v"
  opt :version, "Print version and exit", :short => "-V"
end

RestClient.proxy = ENV["#{PROTOCOL}_proxy"] if ENV["#{PROTOCOL}_proxy"]
RestClient.log = STDOUT if opts[:verbose]
LOG = STDOUT if opts[:verbose]

log "Using proxy: #{ENV["#{PROTOCOL}_proxy"]}"

begin
  if opts[:ggit] or opts[:gsvn]
    scheme = "svn diff"
    if opts[:ggit]
      scheme = "git diff"
    end
    dir = %x( pwd )
    if ARGV[0]
      dir = ARGV[0]
    end
    log "Generating #{scheme} diff for #{dir}"
    content = %x( cd '#{ARGV[0]}'; #{scheme};)
  else
    content = ARGF.read
  end
  response = RestClient.post "#{opts[:url]}/#{PATH}", { 'content' => content }.to_json, :content_type => :json, :accept => :json
  puts JSON.parse(response)['url']
rescue => e
  STDERR.puts JSON.parse(e.response)["errors"]
  exit 1
end
