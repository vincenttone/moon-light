require File.dirname(__FILE__) + '/ski.rb'

x, y, z = SKISymbol.new(:x), SKISymbol.new(:y), SKISymbol.new(:z)
p S.call(x, y, z)

expression = SKICall.new(SKICall.new(SKICall.new(S, x), y), z)
p combinator = expression.left.left.left
p first_argument = expression.left.left.right
p second_argument = expression.left.right
p third_argument = expression.right
p combinator.call(first_argument, second_argument, third_argument)

p expression
p combinator = expression.combinator
p arguments = expression.arguments
p combinator.call(*arguments)

puts '---------------------------'
p swap = SKICall.new(SKICall.new(S, SKICall.new(K, SKICall.new(S, I))), K)
p expression = SKICall.new(SKICall.new(swap, x), y)
while expression.reducible?
  puts expression
  expression = expression.reduce
end
p expression
