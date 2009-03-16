Benchmarking Hash.from_xml with a 1.7 MB xml file in edge Rails 2.3.1 using 
the new XmlMini.backend capability to choose REXML (default) Nokogiri, libxml-ruby.

Note: I've added a new JDOM backend see this Rails lighthouse ticket:

  Add JDOM (JRuby) as XmlMini backend
  http://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/2238-add-jdom-jruby-as-xmlmini-backend

However the liobxml backend has errors for which there aren't tests in rails.

See the end of this readme.

jruby 1.3.0 (ruby 1.8.6 patchlevel 287) (2009-03-13 rev 6586)
[amd64-java], platform: Java, version 1.6.0_03-p3
----------------------------------------------------------------
  rexml      3.84
  jdom       1.25

Ruby version: MRI 1.8.6 (2008-03-03 rev 114), 
platform: universal-darwin9.0
-----------------------------------------------------------------
  rexml     13.079
  libxml     0.489
  nokogiri   7.954


summary: libxml-ruby was 25x faster than REXML while nokogiri was only 1.6 times 
faster while JRuby ran the REXML backend 3 times faster than MRI 1.8.6 and the 
JDOM backend 10 times faster.

New XmlMini.backend capability described here:

  Alternative XML parsers support in ActiveSupport for ActiveResource
  http://rails.lighthouseapp.com/projects/8994/tickets/2084-alternative-xml-parsers-support-in-activesupport-for-activeresource

The results below were collected using this Rails commit:

  Sat Mar 14 10:42:02 2009 -0500
  http://github.com/rails/rails/commit/7706b57034e91820cf83445aede57c54ab66ac2d

[rails_hash_from_xml]$ export RAILS_SOURCE=/Users/stephen/dev/ruby/src/gems/rails.git
[rails_hash_from_xml]$ ruby -I$RAILS_SOURCE/activesupport/lib bench_hash_from_xml.rb

Ruby version: MRI 1.8.6 (2008-03-03 rev 114), platform: universal-darwin9.0

1 times: Run Rails Hash.from_xml conversion on 1.8 MB XML document.

Using Rails ActiveSupport::XmlMini backends: REXML, Nokogiri 1.2.1, libxml-ruby 1.1.2
running benchmark once.

Rehearsal --------------------------------------------
rexml     12.560000   0.170000  12.730000 ( 13.174433)
libxml     0.540000   0.010000   0.550000 (  0.572447)
nokogiri   7.750000   0.090000   7.840000 (  8.041351)
---------------------------------- total: 21.120000sec

               user     system      total        real
rexml     12.130000   0.130000  12.260000 ( 12.649212)
libxml     0.470000   0.010000   0.480000 (  0.493954)
nokogiri   7.320000   0.080000   7.400000 (  7.781733)


[rails_hash_from_xml (master)]$ java -version
java version "1.5.0_16"
Java(TM) 2 Runtime Environment, Standard Edition (build 1.5.0_16-b06-284)
Java HotSpot(TM) Client VM (build 1.5.0_16-133, mixed mode, sharing)

[rails_hash_from_xml (master)]$ jruby -I$RAILS_SOURCE/activesupport/lib bench_hash_from_xml.rb

jruby 1.3.0 (ruby 1.8.6p287) (2009-03-16 r6586) (Java HotSpot(TM) Client VM 1.5.0_16) [i386-java], platform: Java, version 1.5.0_16

1 times: Run Rails Hash.from_xml conversion on 1.8 MB XML document.

Using Rails ActiveSupport::XmlMini backends: REXML
running benchmark once.

Rehearsal -----------------------------------------
rexml   6.259000   0.000000   6.259000 (  6.259000)
jdom    2.356000   0.000000   2.356000 (  2.356000)
-------------------------------- total: 8.615000sec

            user     system      total        real
rexml   4.788000   0.000000   4.788000 (  4.789000)
jdom    1.878000   0.000000   1.878000 (  1.878000)

[rails_hash_from_xml (master)]$ jruby -J-server -I$RAILS_SOURCE/activesupport/lib bench_hash_from_xml.rb

jruby 1.3.0 (ruby 1.8.6p287) (2009-03-16 r6586) (Java HotSpot(TM) Server VM 1.5.0_16) [i386-java], platform: Java, version 1.5.0_16

1 times: Run Rails Hash.from_xml conversion on 1.8 MB XML document.

Using Rails ActiveSupport::XmlMini backends: REXML
running benchmark once.

Rehearsal -----------------------------------------
rexml   8.236000   0.000000   8.236000 (  8.236000)
jdom    4.277000   0.000000   4.277000 (  4.277000)
------------------------------- total: 12.513000sec

            user     system      total        real
rexml   5.068000   0.000000   5.068000 (  5.069000)
jdom    1.293000   0.000000   1.293000 (  1.293000)

[rails_hash_from_xml (master)]$ pickjdk
 1) 1.3.1
 2) 1.4.2
 3) 1.5.0
 4) 1.6.0
 5) Soylatte-amd64
 6) Soylatte16-i386-1.0.3
 7) 1.7.0
 8) None
Choose one of the above [1-8]: 4

[rails_hash_from_xml (master)]$ jruby -I$RAILS_SOURCE/activesupport/lib bench_hash_from_xml.rb 2

jruby 1.3.0 (ruby 1.8.6p287) (2009-03-16 r6586) (Java HotSpot(TM) 64-Bit Server VM 1.6.0_07) [x86_64-java], platform: Java, version 1.6.0_07

1 times: Run Rails Hash.from_xml conversion on 1.8 MB XML document.

Using Rails ActiveSupport::XmlMini backends: REXML
running benchmark 3 times.

Rehearsal -----------------------------------------
rexml   9.199000   0.000000   9.199000 (  9.199000)
jdom    8.638000   0.000000   8.638000 (  8.638000)
------------------------------- total: 17.837000sec

            user     system      total        real
rexml   3.629000   0.000000   3.629000 (  3.629000)
jdom    1.169000   0.000000   1.169000 (  1.169000)

Rehearsal -----------------------------------------
rexml   3.815000   0.000000   3.815000 (  3.814000)
jdom    2.028000   0.000000   2.028000 (  2.028000)
-------------------------------- total: 5.843000sec

            user     system      total        real
rexml   3.316000   0.000000   3.316000 (  3.315000)
jdom    1.073000   0.000000   1.073000 (  1.073000)

---------------------------------------------------------------------------------------

Testing the equivalence of the alternate backends to REXML:

JRuby JDOM backend

[rails_hash_from_xml (master)]$ jruby -I$RAILS_SOURCE/activesupport/lib test/test_rexml_equality.rb 
Testing xml_mini backends: JDOM
Loaded suite test/test_rexml_equality
Started
..........
Finished in 0.547 seconds.

10 tests, 10 assertions, 0 failures, 0 errors


Nokogiri and libxml-ruby:

[rails_hash_from_xml (master)]$ ruby -I$RAILS_SOURCE/activesupport/lib test/test_rexml_equality.rb 
Testing xml_mini backends: Nokogiri LibXML
Loaded suite test/test_rexml_equality
Started
....F.............F.
Finished in 0.165816 seconds.

  1) Failure:
test_children_with_non_adjacent_comparing_LibXML_to_rexml(TestRexmlEquality) [test/test_rexml_equality.rb:151]:
<{"root"=>
  {"__content__"=>"\n    good\n    \n    morning\n  ",
   "products"=>{"__content__"=>"\n      hello everyone\n    "}}}> expected but was
<{"root"=>
  {"__content__"=>"\n    morning\n  ",
   "products"=>{"__content__"=>"\n      hello everyone\n    "}}}>.

  2) Failure:
test_two_lists_in_a_collection_comparing_LibXML_to_rexml(TestRexmlEquality) [test/test_rexml_equality.rb:151]:
<{"collection"=>
  {"list"=>
    {"definition"=>
      [{"word"=>"Evaporation",
        "definition"=>
         "Evaporation is the process of changing from a liquid to a gas, for example, water changing from a liquid into water vapor."},
       {"word"=>"Condensation",
        "definition"=>
         "Condensation is the process of changing from a gas to a liquid, for example, water changing from water vapor into a liquid."}],
     "object"=>[{"id"=>"123"}, {"id"=>"456"}]}}}> expected but was
<{"collection"=>
  {"list"=>
    {"object"=>
      [{"id"=>"123"},
       {"id"=>"456"},
       {"word"=>"Evaporation",
        "definition"=>
         "Evaporation is the process of changing from a liquid to a gas, for example, water changing from a liquid into water vapor."},
       {"word"=>"Condensation",
        "definition"=>
         "Condensation is the process of changing from a gas to a liquid, for example, water changing from water vapor into a liquid."}]}}}>.

20 tests, 20 assertions, 2 failures, 0 errors
[rails_hash_from_xml (master)]$