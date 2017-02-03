require File.dirname(__FILE__) + '/pattern.rb'

pattern = Repeat.new(
                     Choose.new(
                                Concatenate.new(Literal.new('a'), Literal.new('b')),
                                Literal.new('a')
                                )
                     )
p pattern

nfa_design = Empty.new.to_nfa_design
p nfa_design.accepts?('')
p nfa_design.accepts?('a')

nfa_design = Literal.new('a').to_nfa_design
p nfa_design.accepts?('')
p nfa_design.accepts?('a')
p nfa_design.accepts?('b')

Empty.new.matches?('a')
p Literal.new('a').matches?('a')

pattern = Concatenate.new(Literal.new('a'), Literal.new('b'))
p pattern
p pattern.matches?('a')
p pattern.matches?('ab')
p pattern.matches?('abc')

pattern = Concatenate.new(
                          Literal.new('a'),
                          Concatenate.new(Literal.new('b'), Literal.new('c'))
                          )
p pattern
p pattern.matches?('a')
p pattern.matches?('ab')
p pattern.matches?('abc')

pattern = Choose.new(Literal.new('a'), Literal.new('b'))
p pattern
p pattern.matches?('a')
p pattern.matches?('b')
p pattern.matches?('c')

pattern = Repeat.new(Literal.new('a'))
p pattern
p pattern.matches?('')
p pattern.matches?('a')
p pattern.matches?('aaaa')
p pattern.matches?('b')

pattern = Repeat.new(
                     Concatenate.new(
                                     Literal.new('a'),
                                     Choose.new(Empty.new, Literal.new('b'))
                                     )
                     )
p pattern
p pattern.matches?('')
p pattern.matches?('a')
p pattern.matches?('ab')
p pattern.matches?('aba')
p pattern.matches?('abab')
p pattern.matches?('abaab')
p pattern.matches?('abba')
