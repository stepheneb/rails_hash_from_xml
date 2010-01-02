require 'jruby'
include Java 

java_import javax.xml.parsers.DocumentBuilder
java_import javax.xml.parsers.DocumentBuilderFactory
java_import java.io.StringReader
java_import org.xml.sax.InputSource

@dbf = DocumentBuilderFactory.new_instance

doc = @dbf.new_document_builder.parse("xml/77360.otml")
puts doc.getElementsByTagName('float').get_length

xml_string = File.read("xml/77360.otml")
xml_string_reader = StringReader.new(xml_string)
xml_input_source = InputSource.new(xml_string_reader)

doc = @dbf.new_document_builder.parse(xml_input_source)

puts doc.getElementsByTagName('float').get_length
