require_relative 'mecab_natto'

module Morph
  def init_analyzer
    MeCabNatto::setarg('-F%m\s%F-[0,1,2]')
  end

  def analyze(text)
    # 形態素解析の出力を表層形と品詞を要素にした配列にして
    # 解析結果の配列に格納する
    analysis_result = []
    MeCabNatto::analyze(text).each do |part|
      analysis_result.push(part.feature.split(/ /)) if !part.is_eos?
    end

    return analysis_result
  end

  def keyword?(part)
    return /名詞-(一般|固有名詞|サ変接続|形容動詞語幹)/ =~ part
  end

  def sentence?(parts)
    num_noun = 0
    num_mark = 0
    parts.each do |w, part|
      case part
      when /^名詞/
        num_noun += 1
      when /^記号-(?!(読点)|(句点))/
        num_mark += 1
      end
    end

    return parts.size > (num_noun + num_mark) * 2
  end

  module_function :init_analyzer, :analyze, :keyword?, :sentence?
end
