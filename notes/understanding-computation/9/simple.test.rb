require File.dirname(__FILE__) + '/simple.rb'

p expression = Add.new(Variable.new(:x), Number.new(1))
p expression.evaluate({x: Number.new(2)})
p statement = Assign.new(:y, Number.new(3))
p statement.evaluate({ x: Number.new(1) })

=begin
puts '~~~~~~~~~~~~~~~~~~~'
p Add.new(Number.new(1), Number.new(2)).type
p Add.new(Number.new(1), Boolean.new(true)).type
p LessThan.new(Number.new(1), Number.new(2)).type
p LessThan.new(Number.new(1), Boolean.new(true)).type
=end

puts '~~~~~~~~~~~~~~~~~~~'
p expression = Add.new(Variable.new(:x), Variable.new(:y))
p expression.type({})
p expression.type({ x: Type::NUMBER, y: Type::NUMBER })
p expression.type({ x: Type::NUMBER, y: Type::BOOLEAN })

p If.new(
         LessThan.new(Number.new(1), Number.new(2)), DoNothing.new, DoNothing.new
         ).type({})
p If.new(
         Add.new(Number.new(1), Number.new(2)), DoNothing.new, DoNothing.new
         ).type({})
p While.new(Variable.new(:x), DoNothing.new).type({ x: Type::BOOLEAN })
p While.new(Variable.new(:x), DoNothing.new).type({ x: Type::NUMBER })

p statement = While.new(
                        LessThan.new(Variable.new(:x), Number.new(5)),
                        Assign.new(:x, Add.new(Variable.new(:x), Number.new(3)))
                        )
p statement.type({})
p statement.type({ x: Type::NUMBER })
p statement.type({ x: Type::BOOLEAN })
