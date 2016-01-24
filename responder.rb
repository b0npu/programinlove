class Responder
  def initialize(name, dictionary)
    @name = name
    @dictionary = dictionary
  end

  def response(input)
    return ''
  end

  attr_reader :name
end

class WhatResponder < Responder
  def response(input)
    return "#{input}ってなに？"
  end
end

class RandomResponder < Responder
  def response(input)
    return select_random(@dictionary.random)
  end
end

class PatternResponder < Responder
  def response(input)
    @dictionary.pattern.each do |ptn_item|
      if m = input.match(ptn_item['pattern'])
        resp = select_random(ptn_item['phrases'].split('|'))
        return resp.gsub(/%match%/, m.to_s)
      end
    end

    return select_random(@dictionary.random)
  end
end
