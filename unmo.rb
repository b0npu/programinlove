require_relative 'responder'

class Unmo
  def initialize(name)
    @name = name
    @resp_what = WhatResponder.new('What')
    @resp_random = RandomResponder.new('Random')
    @responder = @resp_random
  end

  def dialogue(input)
    @responder = rand(2) == 0 ? @resp_what : @resp_random
    return @responder.response(input)
  end

  def responder_name
    return @responder.name
  end

  def name
    return @name
  end
end
