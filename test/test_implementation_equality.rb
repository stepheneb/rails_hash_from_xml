require 'test/unit'
require 'activesupport'
require 'active_support/xml_mini'

xml_mini_backends = []

# The JDOM JRuby backendw ill only work with this patch applied to rails: 
#   http://rails.lighthouseapp.com/projects/8994/tickets/2238-add-jdom-jruby-as-xmlmini-backend
if RUBY_PLATFORM =~ /java/
  xml_mini_backends << 'JDOM'
else
  begin
    gem 'nokogiri', '>= 1.1.1'
    xml_mini_backends << 'Nokogiri'
  rescue Gem::LoadError
    # Skip nokogiri tests
  end

  begin
    gem 'libxml-ruby', '>= 1.1.2'
    xml_mini_backends << 'LibXML'
  rescue Gem::LoadError
    # Skip nokogiri tests
  end
end

XML_MINI_BACKENDS = xml_mini_backends

puts "Testing xml_mini backends: #{XML_MINI_BACKENDS.join(' ')}"

class TestImplementationEquality < Test::Unit::TestCase
  include ActiveSupport

  XmlMini.backend = "REXML"
  WG_32937_77360_XML  = File.read(
    File.join(File.dirname(__FILE__), '..', 'xml', "77360.otml")
  )
  REXML_BIG_HASH = Hash.from_xml(WG_32937_77360_XML)

  COLLECTION_XML  = File.read(
    File.join(File.dirname(__FILE__), '..', 'xml', "collection.xml")
  )
  REXML_HASH = Hash.from_xml(COLLECTION_XML)

  if XML_MINI_BACKENDS.find {|b| b == 'Nokogiri'}
    def test_nokogiri_equals_rexml
      XmlMini.backend = "Nokogiri"
      assert_equal(REXML_HASH, Hash.from_xml(COLLECTION_XML))
      assert_equal(REXML_BIG_HASH, Hash.from_xml(WG_32937_77360_XML))
    end
  end

  if XML_MINI_BACKENDS.find {|b| b == 'LibXML'}
    def test_libxml_equals_rexml
      XmlMini.backend = "LibXML"
      assert_equal(REXML_HASH, Hash.from_xml(COLLECTION_XML))
      assert_equal(REXML_BIG_HASH, Hash.from_xml(WG_32937_77360_XML))
    end
  end

  if XML_MINI_BACKENDS.find {|b| b == 'JDOM'}
    def test_jdom_equals_rexml
      XmlMini.backend = "JDOM"
      assert_equal(REXML_HASH, Hash.from_xml(COLLECTION_XML))
      assert_equal(REXML_BIG_HASH, Hash.from_xml(WG_32937_77360_XML))
    end
  end

end
