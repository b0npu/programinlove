class Responder
  def initialize(name)
    @name = name
  end

  def response(input)
    return ''
  end

  def name
    return @name
  end
end

class WhatResponder < Responder
  def response(input)
    return "#{input}ってなに？"
  end
end

class RandomResponder < Responder
  def initialize(name)
    super
    @responses = ['今日はさむいね', 'チョコたべたい', 'きのう10円ひろった']
  end

  def response(input)
    return @responses[rand(@responses.size)]
  end
end
