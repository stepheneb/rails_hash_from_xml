require 'test/unit'
require 'activesupport'
require 'active_support/xml_mini'

xml_mini_backends = []

# The JDOM JRuby backendw will only work with this patch applied to rails: 
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

  XML_MINI_BACKENDS.each do |backend|
    from_xml_tests.each do |name, xml|
      define_method "test_#{name}_comparing_#{backend.downcase}_to_rexml".to_sym do
        input_xml = <<-eoxml
        #{xml}
        eoxml
        rexml_hash = XmlMini.with_backend('REXML') { XmlMini.parse(input_xml) }
        alternate_hash = XmlMini.with_backend(backend) { XmlMini.parse(input_xml) }
        assert_equal(rexml_hash, alternate_hash)
      end
    end

    define_method "test_setting_#{backend.downcase}_as_backend".to_sym do
      XmlMini.backend = backend
      assert_equal ActiveSupport.const_get("XmlMini_#{backend}"), XmlMini.backend
    end

    define_method "test_#{backend.downcase}_blank_returns_empty_hash".to_sym do
      assert_equal({}, XmlMini.with_backend(backend) { XmlMini.parse(nil) } )
      assert_equal({}, XmlMini.with_backend(backend) { XmlMini.parse('') } )
    end

    define_method "test_file_from_xml_comparing_#{backend.downcase}_to_rexml".to_sym do
      input_xml = <<-eoxml
      <blog>
        <logo type="file" name="logo.png" content_type="image/png">R0lGODlhkACZAPUAAM5lcfjrtMQCG=\n</logo>
      </blog>
      eoxml
      hash = XmlMini.with_backend(backend) { Hash.from_xml(input_xml) }
      assert hash.has_key?('blog')
      assert hash['blog'].has_key?('logo')
      file = hash['blog']['logo']
      assert_equal 'logo.png', file.original_filename
      assert_equal 'image/png', file.content_type
    end    
  end
end