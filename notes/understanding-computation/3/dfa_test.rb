require File.dirname(__FILE__) + '/dfa.rb'

rulebook = DFARulebook.new([
                            FARule.new(1, 'a', 2),
                            FARule.new(1, 'b', 1),
                            FARule.new(2, 'a', 2),
                            FARule.new(2, 'b', 3),
                            FARule.new(3, 'a', 3),
                            FARule.new(3, 'a', 3),
])
p rulebook.next_state(1, 'a')
p rulebook.next_state(1, 'b')
p rulebook.next_state(2, 'b')

p DFA.new(1, [1, 3], rulebook).accepting?
p DFA.new(1, [3], rulebook).accepting?

dfa = DFA.new(1, [3], rulebook);
p dfa.accepting?
dfa.read_character('b');
p dfa.accepting?
3.times do dfa.read_character('a') end;
p dfa.accepting?
dfa.read_character('b');
p dfa.accepting?

dfa = DFA.new(1, [3], rulebook); dfa.accepting?
dfa.read_string('baaab');
p dfa.accepting?

dfa_design = DFADesign.new(1, [3], rulebook)
p dfa_design.accepts?('a')
p dfa_design.accepts?('baa')
p dfa_design.accepts?('baba')
