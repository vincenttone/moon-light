require File.dirname(__FILE__) + '/dpda.rb'

stack = Stack.new(['a', 'b', 'c', 'd', 'e'])
p stack.top
p stack.pop.pop.top
p stack.push('x').push('y').top
p stack.push('x').push('y').pop.top

p '----------------'
rule = PDARule.new(1, '(', 2, '$', ['b', '$'])
configuration = PDAConfiguration.new(1, Stack.new(['$']))
p rule.applies_to?(configuration, '(')
p rule.follow(configuration)

p '----------------'
rulebook = DPDARulebook.new([
                             PDARule.new(1, '(', 2, '$', ['b', '$']),
                             PDARule.new(2, '(', 2, 'b', ['b', 'b']),
                             PDARule.new(2, ')', 2, 'b', []),
                             PDARule.new(2, nil, 1, '$', ['$'])
                            ])
p configuration = rulebook.next_configuration(configuration, '(')
p configuration = rulebook.next_configuration(configuration, '(')
p configuration = rulebook.next_configuration(configuration, ')')

p '---------'
dpda = DPDA.new(PDAConfiguration.new(1, Stack.new(['$'])), [1], rulebook)
p dpda.accepting?
p dpda.read_string('(()');
p dpda.accepting?
p dpda.current_configuration

p '------------'
p configuration = PDAConfiguration.new(2, Stack.new(['$']))
p rulebook.follow_free_moves(configuration)

p '-----------'
dpda = DPDA.new(PDAConfiguration.new(1, Stack.new(['$'])), [1], rulebook)
dpda.read_string('(()(')
p dpda.accepting?
p dpda.current_configuration
dpda.read_string('))()')
p dpda.accepting?
p dpda.current_configuration

p '-----------'
dpda_design = DPDADesign.new(1, '$', [1], rulebook)
p dpda_design.accepts?('(((((((((())))))))))')
p dpda_design.accepts?('()(())((()))(()(()))')
p dpda_design.accepts?('(()(()(()()(()()))()')

# dpda_design.accepts?('())')

dpda = DPDA.new(PDAConfiguration.new(1, Stack.new(['$'])), [1], rulebook)
dpda.read_string('())')
p dpda.current_configuration
p dpda.accepting?
p dpda.stuck?
p dpda_design.accepts?('())')
