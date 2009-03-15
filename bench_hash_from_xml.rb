# Benchmark Rails Hash.from_xml conversion on 1.8 MB XML document.
#
# file: bench_hash_from_xml.rb
#
# To run in Ruby using rails source:
#
#   export RAILS_SOURCE=/Users/stephen/dev/ruby/src/gems/rails.git
#   ruby -I$RAILS_SOURCE/activesupport/lib bench_hash_from_xml.rb
#
require 'rubygems'
require 'benchmark'
require 'activesupport'
require 'active_support/xml_mini'
include ActiveSupport

# This monkeypatch to String adds support for "Nan".to_f => NaN
Float::NAN_VALUE = *['7FF8000000000000'].pack('H*').unpack('G')
Float::NAN_STRING = 'NaN'
class String 
  alias_method :old_to_f, :to_f 
  def to_f
    if self == Float::NAN_STRING
      Float::NAN_VALUE
    else
      old_to_f
    end
  end 
end

if RUBY_PLATFORM =~ /java/
    require 'jruby'
    include Java 
    import javax.xml.parsers.DocumentBuilder
    import javax.xml.parsers.DocumentBuilderFactory
    @dbf = DocumentBuilderFactory.new_instance
    @ruby_info = JRuby.runtime.instance_config.version_string.strip
    @ruby_info << ", platform: Java, version #{java.lang.System.getProperty('java.version')}"
  else
    gem 'nokogiri', '>= 1.1.1'
    gem 'libxml-ruby', '>= 1.1.2'
    require 'nokogiri'
    require 'libxml'
    @ruby_info = "Ruby version: MRI #{RUBY_VERSION} (#{RUBY_RELEASE_DATE} rev #{RUBY_PATCHLEVEL})"
    @ruby_info << ", platform: #{RUBY_PLATFORM}"
end

# require 'ohai'
# ohai = Ohai::System.new
# ohai.all_plugins
# @platform_info = "#{ohai.platform}: #{ohai.platform_version}"

@wg_32937_77360 = File.read("77360.otml")

def hash_from_xml_using_rexml
  XmlMini.backend = "REXML"
  Hash.from_xml(@wg_32937_77360)
end

unless RUBY_PLATFORM =~ /java/ 
  def hash_from_xml_using_nokogiri
    XmlMini.backend = "Nokogiri"
    Hash.from_xml(@wg_32937_77360)
  end

  def hash_from_xml_using_libxml
    XmlMini.backend = "LibXML"
    Hash.from_xml(@wg_32937_77360)
  end
end

if RUBY_PLATFORM =~ /java/ 
  def hash_from_xml_using_jdom
    XmlMini.backend = "JDOM"
    Hash.from_xml(@wg_32937_77360)
  end
end

n = 1
test_iterations = ARGV.first.to_i 
test_iterations = 1 unless test_iterations > 1
puts 
puts @ruby_info
puts
puts "#{n} times: Run Rails Hash.from_xml conversion on 1.8 MB XML document."
puts
print "Using Rails ActiveSupport::XmlMini backends: REXML"
unless RUBY_PLATFORM =~ /java/ 
  puts ", Nokogiri #{Nokogiri::VERSION}, libxml-ruby 1.1.2"
else
  puts
end
print "running benchmark "
if test_iterations == 1 
  puts "once.\n\n"
else
  puts "#{test_iterations} times.\n\n"
end
test_iterations.times do
  Benchmark.bmbm do |x|
    x.report("rexml") { n.times {hash_from_xml_using_rexml} }
    x.report("libxml") { n.times {hash_from_xml_using_libxml} }  unless RUBY_PLATFORM =~ /java/ 
    x.report("nokogiri") { n.times {hash_from_xml_using_nokogiri} }  unless RUBY_PLATFORM =~ /java/ 
    x.report("jdom") { n.times {hash_from_xml_using_jdom} }  if RUBY_PLATFORM =~ /java/ 
  end
  puts
end
