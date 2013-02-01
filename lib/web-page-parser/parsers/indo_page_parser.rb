module WebPageParser
  class IndependentPageParserFactory < WebPageParser::ParserFactory

    URL_RE = ORegexp.new("independent\.ie.*html")

    INVALID_URL_RE = ORegexp.new("sport|comment")

    def self.can_parse?(options)
      url = options[:url].split('#').first
      return nil if INVALID_URL_RE.match(url)
      URL_RE.match(url)
    end

    def self.create(options = {})
      IndependentPageParserV1.new(options)
    end
  end

  class IndependentPageParserV1 < WebPageParser::BaseParser
    # ICONV = nil
    TITLE_RE = ORegexp.new('<meta property="og:title" content="(.+?)"/>')
    #DATE_RE = ORegexp.new('<meta name="datemodified" content="(.*)"', 'i')
    CONTENT_RE = ORegexp.new('<div class="body">(.*?)</div>', 'm')
    STRIP_TAGS_RE = ORegexp.new('</?(strong|a|span|div|img|tr|td|!--|table)[^>]*>','i')
    PARA_RE = Regexp.new(/<(p)[^>]*>(.*?)<\/\1>/i)

    private

    def date_processor
      begin
        # OPD is in GMT/UTC, which DateTime seems to use by default
        @date = DateTime.parse(@date)
      rescue ArgumentError
        @date = Time.now.utc # No Date on page, defaults to this
      end
    end

    def content_processor
      @content = STRIP_TAGS_RE.gsub(@content, '')
      @content = @content.scan(PARA_RE).collect { |a| a[1] }

    end

  end
end
