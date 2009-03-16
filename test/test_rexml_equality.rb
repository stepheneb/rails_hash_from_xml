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

class TestRexmlEquality < Test::Unit::TestCase
  include ActiveSupport

  from_xml_tests = {
  "array_type_makes_an_array" => <<-eoxml
  <blog>
    <posts type="array">
      <post>a post</post>
      <post>another post</post>
    </posts>
  </blog>
  eoxml
  }

  from_xml_tests.merge!({
  "children_with_non_adjacent" => <<-eoxml
  <root>
    good
    <products>
      hello everyone
    </products>
    morning
  </root>
  eoxml
  })

  from_xml_tests.merge!({
  "one_node_document_as_hash" => <<-eoxml
  <products/>
  eoxml
  })

  from_xml_tests.merge!({
  "one_node_with_attributes_document_as_hash" => <<-eoxml
  <products foo="bar"/>
  eoxml
  })

  from_xml_tests.merge!({
  "products_node_with_book_node_as_hash" => <<-eoxml
  <products>
    <book name="awesome" id="12345" />
  </products>
  eoxml
  })

  from_xml_tests.merge!({
  "products_node_with_two_book_nodes_as_hash" =>
  <<-eoxml
  <products>
    <book name="awesome" id="12345" />
    <book name="america" id="67890" />
  </products>
  eoxml
  })

  from_xml_tests.merge!({
  "single_node_with_content_as_hash" => <<-eoxml
  <products>
    hello world
  </products>
  eoxml
  })

  from_xml_tests.merge!({
  "children_with_children" => <<-eoxml
  <root>
    <products>
      <book name="america" id="67890" />
    </products>
  </root>
  eoxml
  })

  from_xml_tests.merge!({
  "children_with_text" => <<-eoxml
  <root>
    <products>
      hello everyone
    </products>
  </root>
  eoxml
  })

  from_xml_tests.merge!({
  "children_with_non_adjacent" => <<-eoxml
  <root>
    good
    <products>
      hello everyone
    </products>
    morning
  </root>
  eoxml
  })

  from_xml_tests.merge!({
  "two_lists_in_a_collection" => <<-eoxml
  <collection>
    <list>
      <object id="123" />
      <object id="456" />
      <definition word="Evaporation" definition="Evaporation is the process of changing from a liquid to a gas, for example, water changing from a liquid into water vapor." />
      <definition word="Condensation" definition="Condensation is the process of changing from a gas to a liquid, for example, water changing from water vapor into a liquid." />
    </list>
  </collection>
  eoxml
  })
  
  FROM_XML_TESTS = from_xml_tests
  
  from_xml_tests.each do |name, xml|
    XML_MINI_BACKENDS.each do |backend|
      test_name = "test_#{name}_comparing_#{backend}_to_rexml"
      define_method test_name.to_sym do
        input_xml = <<-eoxml
        #{xml}
        eoxml
        rexml_hash = XmlMini.with_backend('REXML') { XmlMini.parse(input_xml) }
        alternate_hash = XmlMini.with_backend(backend) { XmlMini.parse(input_xml) }
        assert_equal(rexml_hash, alternate_hash)
      end
    end
  end
end