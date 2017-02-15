require_relative "issn_matcher"

ISSNMatcher.new({sfx_file: "sfxdata.xml", catkey_file: "ckeys022.txt"}).report
