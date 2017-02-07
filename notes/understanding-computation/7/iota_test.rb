require File.dirname(__FILE__) + '/iota.rb'

expression = S.to_iota
while expression.reducible?
  puts expression
  expression = expression.reduce
end
puts expression

puts '-------------------'
expression = K.to_iota
while expression.reducible?
  puts expression
  expression = expression.reduce
end
puts expression

puts '-------------------'
expression = I.to_iota
while expression.reducible?
  puts expression
  expression = expression.reduce
end
puts expression

puts '-------------------'
x, y, z = SKISymbol.new(:x), SKISymbol.new(:y), SKISymbol.new(:z)
identity = SKICall.new(SKICall.new(S, K), SKICall.new(K, K))
expression = SKICall.new(identity, x)
while expression.reducible?
  puts expression
  expression = expression.reduce
end
puts expression

puts '-------------------'
p two = LambdaCalculusParser.new.parse('-> p { -> x { p[p[x]] } }').to_ast
p two.to_ski
p two.to_ski.to_iota

puts '---------------------'
inc, zero = SKISymbol.new(:inc), SKISymbol.new(:zero)
p expression = SKICall.new(SKICall.new(two.to_ski.to_iota, inc), zero)
p expression = expression.reduce while expression.reducible?
