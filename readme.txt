Benchmarking Hash.from_xml with a 1.7 MB xml file in edge Rails 2.3.1 using 
the new XmlMini.backend capability to choose REXML (default) Nokogiri, libxml-ruby.

Note: I've added a new JDOM backend see this Rails lighthouse ticket:

  Add JDOM (JRuby) as XmlMini backend
  http://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/2238-add-jdom-jruby-as-xmlmini-backend


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

[rails_hash_from_xml]$ jruby -J-server -I$RAILS_SOURCE/activesupport/lib bench_hash_from_xml.rb

jruby 1.3.0 (ruby 1.8.6 patchlevel 287) (2009-03-13 rev 6586) [i386-java], platform: Java, version 1.5.0_16

1 times: Run Rails Hash.from_xml conversion on 1.8 MB XML document.

Using Rails ActiveSupport::XmlMini backends: REXML
running benchmark once.

Rehearsal -----------------------------------------
rexml   8.348000   0.000000   8.348000 (  8.348000)
-------------------------------- total: 8.348000sec

            user     system      total        real
rexml   4.852000   0.000000   4.852000 (  4.853000)

[rails_hash_from_xml]$ pickjdk
 1) 1.3.1
 2) 1.4.2
 3) 1.5.0 < CURRENT
 4) 1.6.0
 5) Soylatte-amd64
 6) Soylatte16-i386-1.0.3
 7) 1.7.0
 8) None
Choose one of the above [1-8]: 5

[rails_hash_from_xml]$ jruby -J-server -I$RAILS_SOURCE/activesupport/lib bench_hash_from_xml.rb

jruby 1.3.0 (ruby 1.8.6 patchlevel 287) (2009-03-13 rev 6586) [amd64-java], platform: Java, version 1.6.0_03-p3

1 times: Run Rails Hash.from_xml conversion on 1.8 MB XML document.

Using Rails ActiveSupport::XmlMini backends: REXML
running benchmark once.

Rehearsal -----------------------------------------
rexml   8.585000   0.000000   8.585000 (  8.585000)
-------------------------------- total: 8.585000sec

            user     system      total        real
rexml   3.907000   0.000000   3.907000 (  3.907000)
