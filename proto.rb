class Responder
  def initialize(name)
    @name = name
  end

  def response(input)
    return "#{input}ってなに？"
  end

  def name
    return @name
  end
end

class Unmo
  def initialize(name)
    @name = name
    @responder = Responder.new('What')
  end

  def dialogue(input)
    return @responder.response(input)
  end

  def responder_name
    return @responder.name
  end

  def name
    return @name
  end
end

def prompt(unmo)
  return unmo.name + ':' + unmo.responder_name + '> '
end

puts('Unmo System prototype : proto')
proto = Unmo.new('proto')
while true
  print('> ')
  input = gets
  input.chomp!
  break if input == ''

  response = proto.dialogue(input)
  puts(prompt(proto) + response)
end
