require File.dirname(__FILE__) + '/cyclic_tag_system.rb'
rulebook = CyclicTagRulebook.new([
  CyclicTagRule.new('1'),
  CyclicTagRule.new('0010'),
  CyclicTagRule.new('10')
])
system = TagSystem.new('11', rulebook)
20.times do
  puts system.current_string
  system.step
end
puts system.current_string
