# -*- coding: utf-8 -*-
$:.unshift File.join(File.dirname(__FILE__), '../../lib')
require 'spec/base_parser_spec'
require 'web-page-parser'
include WebPageParser

describe IndependentPageParserFactory do
  before do
    @valid_urls = [
                   "http://www.independent.ie/breaking-news/national-news/republicans-flock-to-price-funeral-3368590.html",
                   "http://www.independent.ie/world-news/coughing-not-music-to-ears-for-classic-fans-3370080.html"
                  ]
    @invalid_urls = [
                     "http://www.independent.com/sport"
                    ]
  end

  it "should detect indo articles from the url" do
    @valid_urls.each do |url|
      IndependentPageParserFactory.can_parse?(:url => url).should be_true
    end
  end

  it "should ignore pages with the wrong url format" do
    @invalid_urls.each do |url|
      IndependentPageParserFactory.can_parse?(:url => url).should be_nil
    end
  end

end


describe IndependentPageParserV1 do

  describe "when parsing the republican article" do
    before do
      @valid_options = {
        :url => 'http://www.independent.ie/breaking-news/national-news/republicans-flock-to-price-funeral-3368590.html',
        :page => File.read("spec/fixtures/indo/indo_republicans-flock-to-price-funeral-3368590.html"),
        :valid_hash => '8e51f6716e16b8bc176d71ae0bf8b954'
      }
      @pa = IndependentPageParserV1.new(@valid_options)
    end

    it "should parse the title" do
      @pa.title.should == "Republicans flock to Price funeral"
    end



    it "should parse the content" do
      @pa.content[1].should ==
          "Her sister, Marian, who is in prison accused of " +
          "dissident republican activity, was not at the " +
          "service at St Agnes Church in Andersonstown, " +
          "west Belfast."
      @pa.content[2].should ==
        "Price, 62, was an unrepentant republican hard-liner who fell out with "+
        "Sinn Fein after the party endorsed the Northern Ireland peace process, "+
        "encouraged the IRA to give up its guns and embraced power-sharing with "+
        "unionists at Stormont."
      @pa.content[9].should ==
        "She spent eight years in jail including several weeks on hunger strike "+
        "before being released in 1980. In recent years she clashed with Sinn Fein "+
        "president Gerry Adams over her allegations that he had been her IRA "+
        "Officer Commanding during the early 1970s."
      @pa.content.last.should == "Press Association"
      @pa.hash.should == @valid_options[:valid_hash]

      @pa.content.size == 12
    end
  end

  describe "when parsing the soldier loss article" do
    before do
      @valid_options = {
        :url => 'http://www.independent.ie/breaking-news/national-news/family-devastated-by-soldiers-loss-3369695.html',
        :page => File.read("spec/fixtures/indo/indo_family-devastated-by-soldiers-loss-3369695.html"),
        :valid_hash => '1c398fbd65cdb7e93010037851da61f5'
      }
      @pa = IndependentPageParserV1.new(@valid_options)
    end

    it "should parse the title" do
      @pa.title.should == "Family devastated by soldier's loss"
    end



    it "should parse the content" do
      @pa.content[0].should ==
          "The devastated family of an army captain found dead in the Brecon "+
          "Beacons have paid tribute to him."

      @pa.content[1].should ==
        "Police are investigating the death of Captain Rob Carnegie, whose body "+
          "was found at Corn Du, Storey Arms, in the Welsh mountain range."

      @pa.content.last.should == "Press Association"
      @pa.hash.should == @valid_options[:valid_hash]

      @pa.content.size == 3
    end
  end
end

