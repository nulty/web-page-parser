module WebPageParser
  class RtePageParserFactory < WebPageParser::ParserFactory
    URL_RE = ORegexp.new("(www\.)?rte\.ie/[a-z-]+/[0-9]{4}/[0-9]{4}/[a-z-]+.[a-z-]{4}")
    INVALID_URL_RE = ORegexp.new("/sport/")

    def self.can_parse?(options)
      url = options[:url].split('#').first
      return nil if INVALID_URL_RE.match(url)
      URL_RE.match(url)
    end
    
    def self.create(options = {})
      RtePageParserV1.new(options)
    end
  end

  class RtePageParserV1 < WebPageParser::BaseParser
    ICONV = nil
    TITLE_RE = ORegexp.new('<meta name="DC.title" scheme="DCTERMS.URI" content="(.*)"', 'i')
    DATE_RE = ORegexp.new('<meta name="datemodified" content="(.*)"', 'i')
    DESC_RE = ORegexp.new('<meta name="description" content="(.*)" />')
    CONTENT_RE = ORegexp.new('itemprop="articleBody"(.*)<div id="user-options-bottom">', 'm')
    STRIP_TAGS_RE = ORegexp.new('</?(strong|br|a|span|div|img|tr|td|!--|table)[^>]*>','i')
    PARA_RE = Regexp.new(/<(p|h2)[^>]*>(.*?)<\/\1>/i)
    KILL_CHARS_RE = ORegexp.new('[\r\n]+')

    private
    
    def date_processor
      begin
        # OPD is in GMT/UTC, which DateTime seems to use by default
        @date = DateTime.parse(@date)
      rescue ArgumentError
        @date = Time.now.utc
      end
    end

    def content_processor
      @content = STRIP_TAGS_RE.gsub(@content, '')
      @content = @content.scan(PARA_RE).collect { |a| a[1] }

      # Workaround => Problem regex matching first paragraph in the article.
      # also content processing doesn't remove "&nbsp;", done
      first_line = decode_entities(iconv(DESC_RE.match(page)[1].to_s))
      @content = @content.unshift(first_line).map {|p| p.gsub('&nbsp;', " ")}
    end
    
  end
end
