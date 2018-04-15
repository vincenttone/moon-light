require File.dirname(__FILE__) + '/tag_system.rb'

rulebook = TagRulebook.new(2, [TagRule.new('a', 'aa'), TagRule.new('b', 'bbbb')])
p system = TagSystem.new('aabbbbbb', rulebook)
4.times do
  puts system.current_string
  system.step
end
puts system.current_string

puts '~~~~~~~~~~double~~~~~~~~~'
rulebook = TagRulebook.new(2, [TagRule.new('a', 'cc'), TagRule.new('b', 'dddd')])
p system = TagSystem.new('aabbbbbb', rulebook)
system.run

puts '~~~~~~~~~half~~~~~~~~~~'
rulebook = TagRulebook.new(2, [TagRule.new('a', 'cc'), TagRule.new('b', 'd')])
system = TagSystem.new('aabbbbbbbbbbbb', rulebook)
system.run

puts '~~~~~~~~~~incr~~~~~~~~~'
rulebook = TagRulebook.new(2, [TagRule.new('a', 'ccdd'), TagRule.new('b', 'dd')])
system = TagSystem.new('aabbbb', rulebook)
system.run

puts '~~~~~~~~~double and incr~~~~~~~~~~'
rulebook = TagRulebook.new(2, [TagRule.new('a', 'cc'), TagRule.new('b', 'dddd'), TagRule.new('c', 'eeff'), TagRule.new('d', 'ff')])
system = TagSystem.new('aabbbb', rulebook)
system.run

puts '~~~~~~~~~test odd even~~~~~~~~~~'
rulebook = TagRulebook.new(2, [TagRule.new('a', 'cc'), TagRule.new('b', 'd'), TagRule.new('c', 'eo'), TagRule.new('d', ''), TagRule.new('e', 'e')])
system = TagSystem.new('aabbbbbbbb', rulebook)
system.run
system = TagSystem.new('aabbbbbbbbbb', rulebook)
system.run
