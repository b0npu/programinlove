require_relative 'unmo'

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
