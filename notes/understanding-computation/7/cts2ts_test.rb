require File.dirname(__FILE__) + '/cts2ts.rb'

puts '~~~~~~~~~~~~~~~~~~~~~~~'
rulebook = TagRulebook.new(2, [TagRule.new('a', 'ccdd'), TagRule.new('b', 'dd')])
system = TagSystem.new('aabbbb', rulebook)
p system.alphabet

puts '~~~~~~~~~~~~~~~~~~~~~~~'
encoder = system.encoder
p encoder.encode_character('c')
p encoder.encode_string('cab')

puts '~~~~~~~~~~~~~~~~~~~~~~~'
rule = system.rulebook.rules.first
p rule.to_cyclic(encoder)

p system.rulebook.cyclic_rules(encoder)
p system.rulebook.cyclic_padding_rules(encoder)

puts '~~~~~~~~~~~~~~~~~~~~~~~'
cyclic_system = system.to_cyclic
cyclic_system.run
