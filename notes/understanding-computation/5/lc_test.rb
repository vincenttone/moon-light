require File.dirname(__FILE__) + '/lambda_calculus.rb'

one = LCFunction.new(:p,
        LCFunction.new(:x,
          LCCall.new(LCVariable.new(:p),
                     LCVariable.new(:x)
         )
        )
      )
p one
increment = LCFunction.new(:n, LCFunction.new(:p,
              LCFunction.new(:x,
                LCCall.new(
                  LCVariable.new(:p),
                  LCCall.new(
                    LCCall.new(LCVariable.new(:n), LCVariable.new(:p)),
                    LCVariable.new(:x)
                  )
) )
) )
p increment
add = LCFunction.new(:m, LCFunction.new(:n,
              LCCall.new(LCCall.new(LCVariable.new(:n), increment), LCVariable.new(:m))
            )
          )
p add

p expression = LCVariable.new(:x)
p expression.replace(:x, LCFunction.new(:y, LCVariable.new(:y)))
p expression.replace(:z, LCFunction.new(:y, LCVariable.new(:y)))

p '-------'
expression = LCCall.new(
               LCCall.new(
                 LCCall.new(
                   LCVariable.new(:a),
                   LCVariable.new(:b)
                 ),
                 LCVariable.new(:c)
               ),
               LCVariable.new(:b)
             )
p expression
p expression.replace(:a, LCVariable.new(:x))
p expression.replace(:b, LCFunction.new(:x, LCVariable.new(:x)))

p '-------'
expression = LCFunction.new(:y,
               LCCall.new(LCVariable.new(:x), LCVariable.new(:y))
             )
p expression
p expression.replace(:x, LCVariable.new(:z))
p expression.replace(:y, LCVariable.new(:z))

p '-------'
expression = LCCall.new(
               LCCall.new(LCVariable.new(:x), LCVariable.new(:y)),
               LCFunction.new(:y, LCCall.new(LCVariable.new(:y), LCVariable.new(:x)))
             )
p expression
p expression.replace(:x, LCVariable.new(:z))
p expression.replace(:y, LCVariable.new(:z))

p '-----------'
p function = LCFunction.new(:x,
             LCFunction.new(:y,
               LCCall.new(LCVariable.new(:x), LCVariable.new(:y))
             )
           )
p argument = LCFunction.new(:z, LCVariable.new(:z))
p function.call(argument)

p '--------'
p expression = LCCall.new(LCCall.new(add, one), one)
while expression.reducible?
  puts expression
  expression = expression.reduce
end
p expression

p '-------'
inc, zero = LCVariable.new(:inc), LCVariable.new(:zero)
p inc, zero
p expression = LCCall.new(LCCall.new(expression, inc), zero)

while expression.reducible?
  puts expression
  expression = expression.reduce
end
p expression
