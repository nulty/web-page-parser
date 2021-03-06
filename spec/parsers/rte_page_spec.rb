# -*- coding: utf-8 -*-
$:.unshift File.join(File.dirname(__FILE__), '../../lib')
require 'spec/base_parser_spec'
require 'web-page-parser'
include WebPageParser

describe RtePageParserFactory do
  before do
    @valid_urls = [
                   "http://www.rte.ie/news/2013/0128/364816-gardai-liaise-with-psni-in-detective-murder-probe/"
                  ]
    @invalid_urls = [
                     "http://www.rte.ie/gaa"
                    ]
  end

  it "should detect rte articles from the url" do
    @valid_urls.each do |url|
      RtePageParserFactory.can_parse?(:url => url).should be_true
    end
  end

  it "should ignore pages with the wrong url format" do
    @invalid_urls.each do |url|
      RtePageParserFactory.can_parse?(:url => url).should be_nil
    end
  end
  
end


describe RtePageParserV1 do

  describe "when parsing the ryanair article" do
    before do
      @valid_options = { 
        :url => 'http://www.rte.ie/news/2012/0718/aer-lingus-repeats-call-to-reject-ryanair-offer-business.html',
        :page => File.read("spec/fixtures/rte/aer-lingus-repeats-call-to-reject-ryanair-offer-business.html"),
        :valid_hash => '501a0b9f8264c1510d1df0865059391c'
      }
      @pa = RtePageParserV1.new(@valid_options)
    end

    it "should parse the title" do
      @pa.title.should == "Aer Lingus repeats call to reject Ryanair offer"
    end
    
    it "should parse the date in UTC" do
      @pa.date.should == DateTime.parse("2012-07-18T14:27:45")
      @pa.date.zone.should == '+00:00'
    end


    it "should parse the content" do
      @pa.content[0].should == "Aer Lingus has issued a statement this morning calling on shareholders to reject Ryanair's offer."

      @pa.content[2].should == "It believes reasons for European commission prohibition is now even stronger as it says the number of routes that Ryanair would monopolise has sharply increased."
      @pa.content[9].should == "An investigation is also being carried out into Ryanair's current holding by the UK Competition Commission."
      @pa.content.last.should == "An investigation is also being carried out into Ryanair's current holding by the UK Competition Commission."
      @pa.content.size.should == 10         
      @pa.hash.should == @valid_options[:valid_hash]
    end
  end

  describe "when parsing the drinking article" do
    before do
      @valid_options = { 
        :url => 'http://www.rte.ie/news/2012/1213/drink-driving-figures.html',
        :page => File.read("spec/fixtures/rte/drink-driving-figures.html"),
        :valid_hash => '7d2106e2c3e0bdb8837730bd989b2b08'
      }
      @pa = RtePageParserV1.new(@valid_options)
    end

    it "should parse the title" do
      @pa.title.should == "Drink-driving arrests fall by 1,800 annually"
    end
    
    it "should parse the date in UTC" do
      @pa.date.should == DateTime.parse("2012-12-13T11:52:02")
      @pa.date.zone.should == '+00:00'
    end


    it "should parse the content" do
      @pa.content[0].should == "Drink-driving arrests by gardaí have fallen by just over 1,800 in the past year after reduced alcohol levels for drivers were introduced."

      @pa.content[2].should == "Releasing official figures today, garda\303\255 said incidents are gradually reducing and are based on a time period after the alcohol permitted in a driver's system was reduced from 80 to 50mg per 100ml of blood last November."
      @pa.content[8].should == "Irish, Latvian and Lithuanian nationals were among the main repeat offenders."
      @pa.content.last.should == "Irish, Latvian and Lithuanian nationals were among the main repeat offenders."
      @pa.content.size.should == 9         
      @pa.hash.should == @valid_options[:valid_hash]
    end
  end

  describe "when parsing the gallagher article" do
    before do
      @valid_options = { 
        :url => 'http://www.rte.ie/news/2012/1213/gallagher-death.html',
        :page => File.read("spec/fixtures/rte/gallagher-death.html"),
        :valid_hash => '7240fb4211ec799fdbe62976e27f0233'
      }
      @pa = RtePageParserV1.new(@valid_options)
    end

    it "should parse the title" do
      @pa.title.should == "Sister of Erin Gallagher dies tragically"
    end
    
    it "should parse the date in UTC" do
      @pa.date.should == DateTime.parse("2012-12-13T17:02:19")
      @pa.date.zone.should == '+00:00'
    end


    it "should parse the content" do
      @pa.content[0].should == "The 15-year-old sister of Erin Gallagher, who died in October by suicide in Ballybofey, Co Donegal, was found dead last night."

      @pa.content[2].should == "Donegal VEC confirmed it had been made aware of \"the tragic death of Shannon Gallagher RIP, a fourth-year student, at Finn Valley College Stranorlar\"."
      @pa.content[9].should == "It also extended its sympathies to the family and friends of Shannon."
      @pa.content.last.should == "Pieta Mid-WestPieta Mid-West, Ardaulin, Mungret, Co LimerickTel: 061-484444 | 061-484646"
      @pa.content.size.should == 19
      @pa.hash.should == @valid_options[:valid_hash]
    end
  end
end
