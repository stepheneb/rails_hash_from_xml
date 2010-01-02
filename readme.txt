Benchmarking ActiveSupport's Hash.from_xml with a 1.7 MB xml file using the 
XmlMini.backend capability to choose REXML (default) Nokogiri, libxml-ruby.

The benchmarks also run in JRuby measuring REXML, JDOM, and Nokogiri (using FFI).

In addition there is a test suite that compare each of the other backends to the results
from REXML.

I've recently run the benchmarks and tests for ActiveSupport in the: Rails 3 master
and 2-3-stable branches:

    master:     abae712213f663b447d49e9b06001cf51e3b5811
    2-3-stable: 37c51594b9610469173f3deee1ffdda4beb3e397

Here are the results from the Rails 3 master branch:

    # Ruby 1.8.6 (2008-08-11 rev 287), platform: universal-darwin9.0
    
    $ ruby -I$RAILS_SOURCE/activesupport/lib bench_hash_from_xml.rb
    
                   user     system      total        real
    REXML     10.960000   0.270000  11.230000 ( 11.464308)
    Nokogiri   1.230000   0.020000   1.250000 (  1.256476)
    LibXML     0.430000   0.000000   0.430000 (  0.434689)

Using: JRuby 1.5.0.dev (ruby 1.8.7 patchlevel 174) (2009-12-31 5cc49c5)
and testing on Java 1.6 and 1.7 running in server mode and reporting the final
measurements after running the whole benchmark twice:

    $ jruby --server -I$RAILS_SOURCE/activesupport/lib bench_hash_from_xml.rb 2

    # OpenJDK Server VM 1.7.0-internal:

                   user     system      total        real
    REXML      3.448000   0.000000   3.448000 (  3.448000)
    JDOM       0.761000   0.000000   0.761000 (  0.761000)
    Nokogiri   6.083000   0.000000   6.083000 (  6.082000)

    # Java HotSpot(TM) 64-Bit Server VM 1.6.0_17:

                   user     system      total        real
    REXML      4.543000   0.000000   4.543000 (  4.543000)
    JDOM       1.033000   0.000000   1.033000 (  1.033000)
    Nokogiri   6.788000   0.000000   6.788000 (  6.788000)

Running a test suite I adapted that compares multiple backends to REXML:

MRI 1.8.6
    
    $ ruby -I$RAILS_SOURCE/activesupport/lib test/test_rexml_equality.rb
    Testing xml_mini backends: Nokogiri, LibXML on ActiveSupport version 3.0.pre
    Loaded suite test/test_rexml_equality
    Started
    ..........................
    Finished in 0.123952 seconds.

    26 tests, 34 assertions, 0 failures, 0 errors

JRuby:

    $ jruby -I$RAILS_SOURCE/activesupport/lib test/test_rexml_equality.rb
    Testing xml_mini backends: JDOM on ActiveSupport version 3.0.pre
    Loaded suite test/test_rexml_equality
    Started
    .............
    Finished in 1.619 seconds.

    13 tests, 17 assertions, 0 failures, 0 errors

The tests also pass in the 2-3-stable branch.

If you are using a Mac and want to get FFI Nokogiri installed in JRuby to use the newer
version of the libxml2 library available with macports set the following environmental
variable in your ~/.bash_profile or ~/.bash_rc: 

    export LD_LIBRARY_PATH=/opt/local/lib

This is only working for me when I also use Java 1.7. Using Java 1.6 I get this warning
from Nokogiri:

    You're using libxml2 version 2.6.16 which is over 4 years old and has
    plenty of bugs.  We suggest that for maximum HTML/XML parsing pleasure, you
    upgrade your version of libxml2 and re-install nokogiri.
