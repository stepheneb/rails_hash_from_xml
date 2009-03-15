require 'jruby'
include Java 

import javax.xml.parsers.DocumentBuilder
import javax.xml.parsers.DocumentBuilderFactory

@dbf = DocumentBuilderFactory.new_instance

doc = @dbf.new_document_builder.parse("77360.otml").get_document_element 
puts doc.getElementsByTagName('float').get_length

xml_string = File.read("77360.otml")

doc = @dbf.new_document_builder.parse(xml_string).get_document_element 
puts doc.getElementsByTagName('float').get_length
