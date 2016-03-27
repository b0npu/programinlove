require_relative 'utils'
require_relative 'morph'
require_relative 'gugulu'

class Responder
  def initialize(name, dictionary)
    @name = name
    @dictionary = dictionary
  end

  def response(input, prts, mood)
    return ''
  end

  attr_reader :name
end

class WhatResponder < Responder
  def response(input, parts, mood)
    return "#{input}ってなに？"
  end
end

class RandomResponder < Responder
  def response(input, parts, mood)
    return select_random(@dictionary.random)
  end
end

class PatternResponder < Responder
  def response(input, parts, mood)
    @dictionary.pattern.each do |ptn_item|
      if m = ptn_item.match(input)
        resp = ptn_item.choice(mood)
        next if resp.nil?
        return resp.gsub(/%match%/, m.to_s)
      end
    end

    return select_random(@dictionary.random)
  end
end

class TemplateResponder < Responder
  def response(input, parts, mood)
    keywords = []
    parts.each do |word, part|
      keywords.push(word) if Morph::keyword?(part)
    end
    count = keywords.size
    if count > 0 and templates = @dictionary.template[count]
      template = select_random(templates)
      return template.gsub(/%noun%/){keywords.shift}
    end

    return select_random(@dictionary.random)
  end
end

class MarkovResponder < Responder
  def response(input, parts, mood)
    keyword, p = parts.find{|w, part| Morph::keyword?(part)}
    resp = @dictionary.markov.generate(keyword)
    return resp unless resp.nil?

    return select_random(@dictionary.random)
  end
end

class GuguluResponder < Responder
  def initialize(name, dictionary)
    @ggl = Gugulu.new
    @query_opts = ''
    super
  end

  def response(input, parts, mood)
    keywords = []
    parts.each{|w, p| keywords.push(w) if Morph::keyword?(p)}
    query = (keywords.empty?) ? input : keywords.join(' ')
    query += ' ' + @query_opts

    begin
      result = @ggl.search(query)
      raise('no results') if result.empty?
      elem = select_random(result)
      sentences = Gugulu::get_sentences(elem[:url])

      markov = Markov.new
      sentences.each do |line|
        parts = Morph::analyze(line)
        markov.add_sentence(parts)
        @dictionary.study(line, parts)
      end

      resp = markov.generate(select_random(keywords))
      return resp unless resp.nil?
    rescue => e
      puts(e.message)
    end

    return select_random(@dictionary.random)
  end
end
