require 'test/unit'
require 'activesupport'
require 'active_support/xml_mini'

class TestImplementationEquality < Test::Unit::TestCase
  include ActiveSupport

  XmlMini.backend = "REXML"
  WG_32937_77360  = File.read(
    File.join(File.dirname(__FILE__), '..', "77360.otml")
  )
  REXML_HASH      = Hash.from_xml(WG_32937_77360)

  def test_nokogiri_equals_rexml
    XmlMini.backend = "Nokogiri"
    assert_equal(REXML_HASH, Hash.from_xml(WG_32937_77360))
  end

  def test_libxml_equals_rexml
    XmlMini.backend = "LibXML"
    assert_equal(REXML_HASH, Hash.from_xml(WG_32937_77360))
  end
end
