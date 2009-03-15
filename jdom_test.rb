require 'jruby'
include Java 

import javax.xml.parsers.DocumentBuilder
import javax.xml.parsers.DocumentBuilderFactory
import java.io.StringReader
import org.xml.sax.InputSource

@dbf = DocumentBuilderFactory.new_instance

doc = @dbf.new_document_builder.parse("77360.otml")
puts doc.getElementsByTagName('float').get_length

xml_string = File.read("77360.otml")
xml_string_reader = StringReader.new(xml_string)
xml_input_source = InputSource.new(xml_string_reader)

doc = @dbf.new_document_builder.parse(xml_input_source)

.get_document_element 
puts doc.getElementsByTagName('float').get_length
