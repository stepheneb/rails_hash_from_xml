# Benchmark Rails Hash.from_xml conversion on 1.8 MB XML document.
#
# file: bench_hash_from_xml.rb
#
# To run in Ruby using rails source:
#
# set RAILS_SOURCE to point to the rails source:
#
#   export RAILS_SOURCE=/Users/stephen/dev/ruby/src/gems/rails.git
#   ruby -I$RAILS_SOURCE/activesupport/lib bench_hash_from_xml.rb
#
require 'rubygems'
require 'benchmark'
require 'i18n'
require 'active_support'
require 'active_support/core_ext/hash/conversions'
require 'active_support/xml_mini'
require 'active_support/version'
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

JRUBY = (RUBY_PLATFORM =~ /java/)

xml_mini_backends = ["REXML"]

if JRUBY
  require 'java'
  include Java
  xml_mini_backends << 'JDOM'
  begin
    gem 'nokogiri', '>= 1.1.1'
    require 'nokogiri'
    xml_mini_backends << 'Nokogiri'
  rescue Gem::LoadError
    # Skip nokogiri tests
  end
else
  begin
    gem 'nokogiri', '>= 1.1.1'
    require 'nokogiri'
    xml_mini_backends << 'Nokogiri'
  rescue Gem::LoadError, LoadError
    # Skip nokogiri tests
  end  
  begin
    gem 'libxml-ruby', '>= 1.1.2'
    require 'libxml'
    xml_mini_backends << 'LibXML'
  rescue Gem::LoadError
    # Skip libxml-ruby tests
  end
end

XML_MINI_BACKENDS = xml_mini_backends

if JRUBY
  java_import javax.xml.parsers.DocumentBuilder
  java_import javax.xml.parsers.DocumentBuilderFactory
  @dbf = DocumentBuilderFactory.new_instance
  @ruby_info = JRuby.runtime.instance_config.version_string.strip
  @ruby_info << ", platform: Java, version #{java.lang.System.getProperty('java.version')}"
else
  @ruby_info = "Ruby version: MRI #{RUBY_VERSION} (#{RUBY_RELEASE_DATE} rev #{RUBY_PATCHLEVEL})"
  @ruby_info << ", platform: #{RUBY_PLATFORM}"
end

# require 'ohai'
# ohai = Ohai::System.new
# ohai.all_plugins
# @platform_info = "#{ohai.platform}: #{ohai.platform_version}"

@wg_32937_77360 = File.read("xml/77360.otml")

def hash_from_xml_using(backend)
  if JRUBY && backend == 'Nokogiri'
    objectspace_state = JRuby.objectspace
    JRuby.objectspace = true
  end
  XmlMini.backend = backend
  Hash.from_xml(@wg_32937_77360)
  if JRUBY && backend == 'Nokogiri'
    JRuby.objectspace = objectspace_state
  end
end

test_iterations = ARGV.first.to_i 
test_iterations = 1 unless test_iterations > 1
puts 
puts "Running in #{@ruby_info}"
puts
puts "Benchmarking xml_mini backends: #{XML_MINI_BACKENDS.join(', ')} on ActiveSupport version #{ActiveSupport::VERSION::STRING}"
puts "running Rails Hash.from_xml conversion on 1.7 MB XML document."
puts
print "Running benchmark "
if test_iterations == 1 
  puts "once with rehearsal.\n\n"
else
  puts "#{test_iterations} times with rehearsals.\n\n"
end

test_iterations.times do
  Benchmark.bmbm do |x|
    XML_MINI_BACKENDS.each do |backend|
      x.report(backend.dup) { hash_from_xml_using(backend) }
    end
  end
  puts
end
