require "marc"

class ISSNMatcher

  attr_reader :sfx_data, :catkeys

  def initialize(options = {})
    read_sfx_file(options[:sfx_file]) if options[:sfx_file]
    read_catkey_file(options[:catkey_file]) if options[:catkey_file]
  end

  def merged(catkey)
    "#{catkey},#{@catkeys[catkey]},#{@sfx_data[@catkeys[catkey]]}"
  end

  def report
    @catkeys.keys.each do |catkey|
      puts merged catkey
    end
  end

  private

  def read_sfx_file(sfx_file)
    @sfx_data = {}
    MARC::XMLReader.new(sfx_file).each{ |rec| @sfx_data[rec['022']['a']] = rec['090']['a'] if (rec['022'] and rec['090']) }
  end

  def read_catkey_file(catkey_file)
    @catkeys = {}
    File.open(catkey_file).each_line{ |line| @catkeys[line.split("|").first] = verified(line.split("|")[1]) }
  end

  def verified(issn)
    /\d{4}-\d{3}\d|X/ =~ issn ? issn : "NO ISSN"
  end
end

