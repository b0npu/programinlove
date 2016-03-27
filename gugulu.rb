require 'open-uri'        # URLを開く
require 'Oga'             # HTMLやXMLをパースする
require 'cgi'             # 日本語をURLエンコード
require_relative 'morph'

class Gugulu
  GOOGLE = "https://www.google.co.jp"

  def search(query)
    # 検索文字列をURLエンコードして取得
    search_word = CGI.escape(query)

    # 検索結果のURLを開いて要素を取得
    query_url = "#{GOOGLE}/search?q=#{search_word}"
    begin
      search_result = open(query_url) do |f|
        # 文字化け対策にutf-8を指定してhtmlを読み込む
        f.read.encode('utf-8')
      end
      get_elements(search_result)
    rescue => e
      # Google検索ができなかった場合はエラーを表示
      puts("Search Error: #{e.message}")
    end
  end

  def get_elements(html)
    element = []
    # HTMLをパースしてリンクとタイトルを取得
    doc = Oga.parse_html(html)
    doc.xpath('//h3/a').each do |node|
      link = node.get('href')
      # open-uriでhttpを開こうとするとエラーが出るので
      # httpsのurlのみ取得する
      if link =~ /^\/url\?q=https:/
        element.push({ title: node.text,
                        url: "#{GOOGLE}#{link}" })
      end
    end

    # 検索結果のリンクが開けるか確認
    element.each do |elem|
      begin
        open(elem[:url])
      rescue => e
        # リンクが開けない場合は配列から削除
        element.delete(elem)
      end
    end
  end

  def self::get_sentences(url)
    html = open(url){|f| f.read}
    return html2sentences(html)
  end

  def self::html2sentences(html)
    html.gsub!(/<!--.*?-->/im, '')
    html.gsub!(/<.*?>/im, '')
    html = CGI.unescapeHTML(html)
    html.gsub!(/&nbsp;/, ' ')
    html.gsub!(/^[\s　]+/, '')
    html.gsub!(/[\s　]+$/, '')
    html.gsub!(/(([。?？!！](?![\r\n]))+)/, "\\1\n")

    sentences = []
    html.split(/\n/).each do |line|
      parts = Morph::analyze(line)
      next unless Morph::sentence?(parts)
      sentences.push(line)
    end
    return sentences
  end
end

if $0 == __FILE__
  Morph::init_analyzer
  ggl = Gugulu.new

  loop do
    print('Search: ')
    line = gets.chomp
    break if line.empty?

    begin
      elements = ggl.search(line)
      elements.each.with_index(1) do |elem, i|
        puts('%d %s'%[i, elem[:title]])
        puts('    ' + elem[:url])
      end
      puts

      loop do
        print('Get: ')
        line = gets.chomp
        break if line.empty?
        no = line.to_i - 1
        next unless elements[no]
        puts(Gugulu::get_sentences(elements[no][:url]))
      end
    rescue => e
      puts("error: " + e.message)
    end
  end
end

