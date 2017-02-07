require File.dirname(__FILE__) + '/ski2lambda.rb'

x, y, z = SKISymbol.new(:x), SKISymbol.new(:y), SKISymbol.new(:z)
p original = SKICall.new(SKICall.new(S, K), I)
p function = original.as_a_function_of(:x)
p function.reducible?

puts '------------------------'
expression = SKICall.new(function, y)
while expression.reducible?
  puts expression
  expression = expression.reduce
end
puts expression
p expression == original

puts '------------------------'
p original = SKICall.new(SKICall.new(S, x), I)
p function = original.as_a_function_of(:x)
p expression = SKICall.new(function, y)
while expression.reducible?
  puts expression
  expression = expression.reduce
end
puts expression
p expression == original

puts '------------------------'
p two = LambdaCalculusParser.new.parse('-> p { -> x { p[p[x]] } }').to_ast
p two.to_ski

puts '------------------------'
inc, zero = SKISymbol.new(:inc), SKISymbol.new(:zero)
p expression = SKICall.new(SKICall.new(two.to_ski, inc), zero)
while expression.reducible?
  puts expression
  expression = expression.reduce
end
puts expression
