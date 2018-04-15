require File.dirname(__FILE__) + '/simple.big-step.rb'

p Number.new(23).evaluate({})
p Variable.new(:x).evaluate({x: Number.new(23)})
p LessThan.new(
               Add.new(Variable.new(:x), Number.new(2)),
               Variable.new(:y)
               ).evaluate({x: Number.new(2), y: Number.new(5)})

p statement = Sequence.new(
                         Assign.new(:x, Add.new(Number.new(1), Number.new(1))),
                         Assign.new(:y, Add.new(Variable.new(:x), Number.new(3)))
                           )
p statement.evaluate({})

p statement = While.new(
                        LessThan.new(Variable.new(:x), Number.new(5)),
                        Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3)))
                      )
p statement.evaluate({x: Number.new(1)})
