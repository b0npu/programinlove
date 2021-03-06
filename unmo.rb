require_relative 'responder'
require_relative 'dictionary'
require_relative 'morph'

class Unmo
  def initialize(name)
    @name = name
    @dictionary = Dictionary.new
    @emotion = Emotion.new(@dictionary)

    @resp_what = WhatResponder.new('What', @dictionary)
    @resp_random = RandomResponder.new('Random', @dictionary)
    @resp_pattern = PatternResponder.new('Pattern', @dictionary)
    @resp_template = TemplateResponder.new('Template', @dictionary)
    @resp_markov = MarkovResponder.new('Markov', @dictionary)
    @resp_gugulu = GuguluResponder.new('Google', @dictionary)
    @responder = @resp_pattern
  end

  def dialogue(input)
    @emotion.update(input)
    parts = Morph::analyze(input)

    case rand(100)
    when 0..19
      @responder = @resp_pattern
    when 20..39
      @responder = @resp_template
    when 40..54
      @responder = @resp_random
    when 55..74
      @responder = @resp_markov
    when 75..94
      @responder = @resp_gugulu
    else
      @responder = @resp_what
    end
    resp = @responder.response(input, parts, @emotion.mood)

    @dictionary.study(input, parts)
    return resp
  end

  def save
    @dictionary.save
  end

  def responder_name
    return @responder.name
  end

  def mood
    return @emotion.mood
  end

  attr_reader :name
end

class Emotion
  MOOD_MIN = -15
  MOOD_MAX = 15
  MOOD_RECOVERY = 0.5

  def initialize(dictionary)
    @dictionary = dictionary
    @mood = 0
  end

  def update(input)
    @dictionary.pattern.each do |ptn_item|
      if ptn_item.match(input)
        adjust_mood(ptn_item.modify)
        break
      end
    end

    if @mood < 0
      @mood += MOOD_RECOVERY
    elsif @mood > 0
      @mood -= MOOD_RECOVERY
    end
  end

  def adjust_mood(val)
    @mood += val
    if @mood > MOOD_MAX
      @mood = MOOD_MAX
    elsif @mood < MOOD_MIN
      @mood = MOOD_MIN
    end
  end

  attr_reader :mood
end
