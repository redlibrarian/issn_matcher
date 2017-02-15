require "marc"

class ISSNMatcher

  attr_reader :sfx_data, :catkeys

  def initialize(options = {})
    @sfx_data = read_sfx_file(options[:sfx_file]) if options[:sfx_file]
    @catkeys = read_catkey_file(options[:catkey_file]) if options[:catkey_file]
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
    MARC::XMLReader.new(sfx_file).each_with_object({}){ |rec,hsh| hsh[rec['022']['a']] = rec['090']['a'] if (rec['022'] and rec['090']) }
  end

  def read_catkey_file(catkey_file)
    File.open(catkey_file).each_with_object({}){ |line,hsh| hsh[line.split("|").first] = verified(line.split("|")[1]) }
  end

  def verified(issn)
    /\d{4}-\d{3}\d|X/ =~ issn ? issn : "NO ISSN"
  end
end

